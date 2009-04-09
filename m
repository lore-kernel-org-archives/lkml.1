Return-Path: <linux-kernel-owner+w=401wt.eu-S935842AbZDIPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935842AbZDIPyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935805AbZDIPxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:53:43 -0400
Received: from NaN.false.org ([208.75.86.248]:50553 "EHLO nan.false.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935809AbZDIPxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:53:42 -0400
X-Greylist: delayed 1420 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 11:53:41 EDT
Date: Thu, 9 Apr 2009 11:29:57 -0400
From: Daniel Jacobowitz <dan@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090409152957.GA7236@caradoc.them.org>
Mail-Followup-To: Catalin Marinas <catalin.marinas@arm.com>,
	Tim Bird <tim.bird@am.sony.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Abhishek Sagar <sagar.abhishek@gmail.com>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <49CA5CFF.8090908@am.sony.com> <1238158688.9698.16.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238158688.9698.16.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.17 (2008-05-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply, I'm way behind on list mail.

On Fri, Mar 27, 2009 at 12:58:08PM +0000, Catalin Marinas wrote:
> Anyway, the EABI toolchain I have (from CodeSourcery) generates
> something like below with -pg for both ARM and Thumb code (so that it
> doesn't rely on the frame pointer):
> 
> 	push	{lr}
> 	bl	__gnu_mcount_nc
> 
> I think this will be (was?) merged into the mainline gcc for ARM. The
> -pg option is still incompatible with -fomit-frame-pointer but maybe it
> shouldn't be anymore.

Was merged.  It'll be in GCC 4.4 and is in our current Lite releases;
it was created to solve precisely this problem.  It should be easy to
apply to an older GCC release if desired, but it's not in existing
FSF releases.

-- 
Daniel Jacobowitz
CodeSourcery
