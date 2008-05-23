Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbYEWUp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbYEWUp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYEWUpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:45:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44819 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756395AbYEWUpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:45:15 -0400
Date: Fri, 23 May 2008 15:48:19 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] use of /sys versus /proc
Message-ID: <20080523204819.GA20374@sgi.com>
References: <20080523131255.C19831F0380@attica.americas.sgi.com> <23175.1211563160@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23175.1211563160@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 01:19:20PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 23 May 2008 08:12:55 CDT, Cliff Wickman said:
> > 
> > I have a need to display TLB shootdown statistics.  (I'm working
> > on a patch to implement this on a new machine at SGI.)
> > 
> > I had planned to display these statistics through /proc
> > as in arch/ia64/sn/kernel/sn2/sn2_smp.c (/proc/sgi_sn/ptc_statistics).
> > 
> > However, considering the general move to reserve /proc for
> > process-related things, I thought the community might prefer the
> > interface to be in /sys.
> 
> Is debugfs an option?

I tried that out and it works about like /proc, which is good.
It doesn't clutter /proc.
Plus it can disappear gracefully from the kernel if CONFIG_DEBUG_FS
is set off.  (it is set on in the default x86_64 configuration)

So thanks for the suggestion.  It may be the answer.

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
