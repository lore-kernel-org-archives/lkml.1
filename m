Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0BRDds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 22:33:48 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:50640 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0BRDdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 22:33:46 -0500
From: Goswin von Brederlow <goswin-v-b@web.de>
To: david@lang.hm
Cc: Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>,
       Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <201002140251.59668.volkerarmin@googlemail.com>
	<4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	<201002141940.35716.volkerarmin@googlemail.com>
	<4B7AD35E.7000405@tmr.com>
	<alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
	<20100217130103.3ca65ef3@notabene.brown>
	<f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
	<4B7BB927.5000305@grumpydevil.homelinux.org>
	<f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com>
	<alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
	<20100217181016.GA14983@emergent.ellipticsemi.com>
Date: Thu, 18 Feb 2010 04:33:34 +0100
In-Reply-To: <20100217181016.GA14983@emergent.ellipticsemi.com> (Nick Bowler's
	message of "Wed, 17 Feb 2010 13:10:16 -0500")
Message-ID: <87sk8z9q0h.fsf@frosties.localdomain>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux, no MULE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18SmX86Wc8ZJkIOHkbv4ajqkCiiszCNsl9Ke7N6
	bomv9LrI9gX4PdQFwtix4jLW1kxu8bUbrW/w8f6hNn1Jdkr8kx
	U4BY6BUjY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Bowler <nbowler@elliptictech.com> writes:

> On 09:41 Wed 17 Feb     , david@lang.hm wrote:
>> for a distro that is trying to make one kernel image run on every
>> possible type of hardware features like initramfs (and udev, modeules,
>> etc) are wonderful.
>> 
>> however for people who run systems that are known ahead of time and
>> static (and who build their own kernels instead of just relying on the
>> distro default kernel), all of this is unnessesary complication, which
>> leaves more room for problems to creep in.
>
> Such people can easily construct an initramfs containing busybox and
> mdadm with a shell script hardcoded to mount their root fs and run
> switch_root.  It's a ~10 minute jobbie that only needs to be done once.

Except when mdadm, cryptsetup, lvm change you need to update it.
Esspecially when you set up a new system that might have newer
metadata.

Also at least Debian doesn't (yet) support a common initramfs for their
kernel packaging. You either build a kernel without need for one or you
have a per kernel initramfs that is automatically build and updated
whenever anything in the initrmafs changes. Not often, but still too
often, the initramfs then doesn't work.

Does any other distribution allow building kernel image rpms that will
use a common initramfs for all kernels?

MfG
        Goswin
