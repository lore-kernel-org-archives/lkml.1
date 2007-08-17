Return-Path: <linux-kernel-owner+w=401wt.eu-S1765529AbXHQVBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765529AbXHQVBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbXHQVBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:01:25 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4458 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872AbXHQVBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:01:24 -0400
Date: Fri, 17 Aug 2007 17:00:57 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070817210057.GB15379@hmsreliant.think-freely.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <20070816123538.GA10430@hmsreliant.think-freely.org> <4379.1187338166@turing-police.cc.vt.edu> <20070817105918.GA13937@hmsreliant.think-freely.org> <20070817124547.5415a839.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817124547.5415a839.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 12:45:47PM -0700, Andrew Morton wrote:
> On Fri, 17 Aug 2007 06:59:18 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Currently, there exists no method for a process to query the resource
> > limits of another process.  They can be inferred via some mechanisms but they
> > cannot be explicitly determined.  Given that this information can be usefull to
> > know during the debugging of an application, I've written this patch which
> > exports all of a processes limits via /proc/<pid>/limits.
> 
> I'm struggling with this a bit.  Sure, it _might_ be handy on some
> occasions to be able to get at this information.  But I've never seen
> anyone ask for it before, and it _is_ determinable by other means, if only
> strace.
> 
> How do we justify adding yet more stuff to the kernel?

Well, In the past yar and a half I've been asked for it twice.  Granted thats
not alot of demand, but neither is the code particularly invasive or complex.
If your concerned about bloat, my first thought would be to add a compile time
config option, which I'm certainly willing to add if the consensus is to do so,
but honestly I thought this was small enough that it didnt' really need it.

As previously mentioned though, the final say as to what is important enough to
make it into the kernel is up to you and Linus.  I think this is worthwhile, but
if I'm in the minority on that, I'll certainly understand

Thanks & Regards
Neil
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
