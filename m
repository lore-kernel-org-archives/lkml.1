Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXHUS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXHUS4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbXHUS4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:56:13 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:29693 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbXHUS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:56:12 -0400
Date: Tue, 21 Aug 2007 11:56:11 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070821185611.GA17822@hexapodia.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <20070816123538.GA10430@hmsreliant.think-freely.org> <4379.1187338166@turing-police.cc.vt.edu> <20070817105918.GA13937@hmsreliant.think-freely.org> <20070817124547.5415a839.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817124547.5415a839.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 12:45:47PM -0700, Andrew Morton wrote:
> On Fri, 17 Aug 2007 06:59:18 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> > Currently, there exists no method for a process to query the resource
> > limits of another process.  They can be inferred via some mechanisms
> > but they cannot be explicitly determined.  Given that this
> > information can be usefull to know during the debugging of an
> > application, I've written this patch which exports all of a
> > processes limits via /proc/<pid>/limits.
> 
> I'm struggling with this a bit.  Sure, it _might_ be handy on some
> occasions to be able to get at this information.  But I've never seen
> anyone ask for it before, and it _is_ determinable by other means, if only
> strace.

I've wanted this information on multiple occasions in the past and was
mystified that there was no way to determine it.  And no, I don't feel
that strace is an answer -- given a running process, how do I use strace
to find out what its current ulimits are?

-andy
