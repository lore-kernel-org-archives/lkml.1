Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449Ab0ABD4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0ABD4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 22:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350Ab0ABD4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 22:56:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:15218 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0ABD4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 22:56:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=isho7+/CLgz/8H2FNOGIVsb2awv75C56dwWHa4OqG8SJ+whH4T1giYmf4pR3JRMXsa
         E/7P589QWSxsqdoz9Kz3/ydnrUjhF1aAW8FBMtNTOIeCL+sFrgwVOUS4nAhWFR5nUf8q
         +ti2g+g1R6/MJHSc7R6iGkxoqBO1zJVHEwaIg=
Date: Sat, 2 Jan 2010 04:56:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Lin Ming <ming.m.lin@intel.com>,
       mingo@elte.hu, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: tbench regression with 2.6.33-rc1
Message-ID: <20100102035644.GC5238@nowhere>
References: <1261739467.10685.18.camel@minggr.sh.intel.com> <1261902760.6201.33.camel@marge.simson.net> <1261904349.15854.2.camel@laptop> <1261906883.5451.1.camel@marge.simson.net> <1261908662.15854.4.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261908662.15854.4.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 11:11:02AM +0100, Peter Zijlstra wrote:
> On Sun, 2009-12-27 at 10:41 +0100, Mike Galbraith wrote:
> > On Sun, 2009-12-27 at 09:59 +0100, Peter Zijlstra wrote:
> > > On Sun, 2009-12-27 at 09:32 +0100, Mike Galbraith wrote:
> > > > Perf also isn't free, and in 33, we lost the ability to config it out,
> > > 
> > > Uhm, that's a plain bug, we should be able to build a kernel without
> > > perf support, does the hw breakpoint support have an unfortunate select
> > > some place or something?
> > 
> > Yeah, it's selected in arch/x86/Kconfig.  The kernel won't build without
> > it either.
> 
> Came from this :/
> 
> Any way we can fix this? Frederic/Ingo?



No way I think.
breakpoints support by ptrace is a builtin option in x86 and
it's implemented on top of perf.

The only solution to solve this would be to make the breakpoints
support optional.

