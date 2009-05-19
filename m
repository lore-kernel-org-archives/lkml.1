Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZESA0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZESA0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 20:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZESA0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 20:26:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57645 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZESA0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 20:26:24 -0400
MIME-Version: 1.0
In-Reply-To: <424718.52835.qm@web32607.mail.mud.yahoo.com>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.scG.LA0DKB@chimera> 
	<424718.52835.qm@web32607.mail.mud.yahoo.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 19 May 2009 02:26:04 +0200
Message-ID: <ac3eb2510905181726q3b996b8ei9c6a74fe1d3bb17d@mail.gmail.com>
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

On Mon, May 18, 2009 at 10:15, Martin Knoblauch <spamtrap@knobisoft.de> wrote:

>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
>> Subject        : Booting very slow
>> Submitter    : Martin Knoblauch
>> Date        : 2009-04-24 12:45 (23 days old)
>> References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4
>
>  The issue is still open. It turns out that starting with 2.6.29-rc1 /proc/mounts already has a "sysfs" line when entering the startup scripts from initrd. This breaks the RHEL4 firmware hotplug script.

Is that possibly a missing/failing "umount /sys" _in_ initramfs, which
leaves the sysfs entry in /proc/mounts behind, which then shows up as
a duplicate when running in the real rootfs?

Thanks,
Kay
