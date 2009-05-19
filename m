Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZESI6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZESI6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZESI6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:58:45 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:62960 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZESI6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:58:44 -0400
MIME-Version: 1.0
In-Reply-To: <783496.86803.qm@web32608.mail.mud.yahoo.com>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.scG.LA0DKB@chimera> 
	<424718.52835.qm@web32607.mail.mud.yahoo.com> <ac3eb2510905181726q3b996b8ei9c6a74fe1d3bb17d@mail.gmail.com> 
	<783496.86803.qm@web32608.mail.mud.yahoo.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 19 May 2009 10:58:24 +0200
Message-ID: <ac3eb2510905190158o6682f7aat62ff66ac9aaa2a74@mail.gmail.com>
Subject: Re: [Bug #13178] Booting very slow
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:22, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
>> >  The issue is still open. It turns out that starting with 2.6.29-rc1
>> /proc/mounts already has a "sysfs" line when entering the startup scripts from
>> initrd. This breaks the RHEL4 firmware hotplug script.
>>
>> Is that possibly a missing/failing "umount /sys" _in_ initramfs, which
>> leaves the sysfs entry in /proc/mounts behind, which then shows up as
>> a duplicate when running in the real rootfs?
>
>  could be. Remains the question, why it never showed up before 2.6.29. I compared my initrd images for 2.6.28 and 2.6.29-rc1, and they only differ in the module-binaries.

I wouldn't be surprised if we are just "too fast" again now with the
async stuff, for another piece of rather fragile userspace bootup
logic, making some wrong assumptions. Are you compiling-in the modules
for the root disk and the root filesystem?

Cheers,
Kay
