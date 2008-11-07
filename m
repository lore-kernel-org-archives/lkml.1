Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYKGSX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYKGSX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYKGSXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:23:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54732 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbYKGSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:23:46 -0500
Date: Fri, 7 Nov 2008 18:23:11 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, Eric Miao <eric.y.miao@gmail.com>,
       Cyril Hrubis <metan@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Message-ID: <20081107182311.GA28600@flint.arm.linux.org.uk>
References: <20081031150601.GA1457@ucw.cz> <20081105142329.GA1724@ucw.cz> <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com> <20081105173303.GC2038@elf.ucw.cz> <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com> <20081106080416.GA1531@ucw.cz> <20081106191424.GA2273@atrey.karlin.mff.cuni.cz> <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com> <20081107142923.GA1616@ucw.cz> <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 05:57:33PM +0300, Dmitry wrote:
> 2008/11/7 Pavel Machek <pavel@suse.cz>:
> > On Fri 2008-11-07 21:23:41, Eric Miao wrote:
> >> Well, IIRC spitz still needs the patch to change the vmlinux.ld.S.
> >> Did you guys ever try that?
> >
> > I never heard about that patch, do you have it handy?
> 
> http://rpsys.net/openzaurus/patches/archive/pxa-linking-bug.patch
> 
> I plan to submit a bit modified version of this patch later.

That doesn't look like something that should be accepted.  Take a moment
to put some thought into the question.  Why should we _allocate_ and
contain the stack in the resulting image?  Does the stack contain any
data that must be pre-initialized?

Obviously not.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
