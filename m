Return-Path: <linux-kernel-owner+w=401wt.eu-S1765247AbXGUMPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765247AbXGUMPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762347AbXGUMP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:15:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762340AbXGUMP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:15:28 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
To: Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Reply-To: 7eggert@gmx.de
Date: Sat, 21 Jul 2007 14:14:41 +0200
References: <8I2t1-7jt-5@gated-at.bofh.it> <8IlPa-3Gl-61@gated-at.bofh.it> <8IzyM-86P-47@gated-at.bofh.it> <8Jb1c-7vL-3@gated-at.bofh.it> <8Jbuh-84N-3@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1ICDr7-0000e9-P4@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX187MnSEzz/VT1OV9q2uJGYiPTbbbn++M5r8+KO
 46oKFg2V3DuLIEM7HMaOP04DcsczzT4681FRWRXDLjtev+j4w7
 nZ6ngHuxzq9wdBkYJgxZw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote:
> On Fri, Jul 20, 2007 at 08:21:39PM -0400, Rob Landley wrote:

>> I'm not trying to document /sys/devices.  I'm trying to document hotplug,
>> populating /dev, and things like firmware loading that fall out of that.
>> This requires use of sysfs, and I'm only trying to document as much of sysfs
>> as you need to do that.
> 
> Like I stated before, you do not need to even have sysfs mounted to have
> a dynamic /dev.
> 
> And why do you need to document populating /dev dynamically?  udev
> already solves this problem for you, it's not like people are going off
> and reinventing udev for their own enjoyment would not at least look at
> how it solves this problem first.

Turning your words around, you get: "Whatever one of these programs does
documents how dynamic devices should be handled." If this is true, any
change that makes one of these programs break is a kernel bug.

Besides that: How am I supposed to be able to correctly change udev if
there is no document telling me what would work and what happens to
work by accident?

> To do otherwise would be foolish :)

Some people like to fool around and create even smaller wheels.
E.g. I'm changing the ACPI button driver to just call Ctrl_alt_del
in order not to have an extra process running and free 0.2 % of my RAM.

> Firmware loading is fine to document if you wish to do so.  But again,
> why?  We already have multiple userspace programs that provide this
> feature for them.  Perhaps you want to document how to add firmware to a
> system in order for these different programs to pick them up?

I once tried to install a firmware for hotplug. Even finding the place whre
I'm supposed to put it was harder than rewriting that *beep* from start,
but I could not rewrite it because I didn't have any documentation.
Even digging in that pile of wrapper scrips in order to debug that thing
was a nightmare. (Having a number of places where the firmware will be
expected in one of many versions and formats stored using one of many
filenames can drive you nuts.)

> Or perhaps you want to document how to add this kind of functionality to
> your kernel driver so that it can handle firmware loading by using the
> firmware interface that the kernel provides?

I suppose that's missing, too. Or scattered in a number of contradicting
and mostly outdated howtos across the internet.

> If you just want to document the hotplug/uevent api, then do just that.
> However I think you are overreaching with your scope here and getting
> mighty confused in the process.

In other words: Grasping sysfs is not a feasible task? If this is true,
how can anybody reliably use sysfs?
-- 
Top 100 things you don't want the sysadmin to say:
99. Shit!!

Friﬂ, Spammer: G@r.7eggert.dyndns.org Sln3@hI.7eggert.dyndns.org
