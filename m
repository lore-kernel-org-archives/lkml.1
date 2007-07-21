Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXGUTd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXGUTd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbXGUTdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:33:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:61577 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbXGUTdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Pkr6c+ZymR396EgVBvhbZTUm48Yn51AWRyO9EykZI0ZfeNZMNeZDtl0sAhqmZ/GGgPPuOYQi/0msKyaT4n2tIpB3A+pdKPtgZYYfzgAN6PkaBxxdeXaRZaiuGj6eihP8W89BCU6eC4K0rkf3LzN//j0+q6yoIVOUO+NGHbceya0=
Message-ID: <46A25F2A.6020603@googlemail.com>
Date: Sat, 21 Jul 2007 21:31:54 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <ak@suse.de>, Satyam Sharma <satyam.sharma@gmail.com>,
       Greg KH <gregkh@suse.de>, rdunlap@xenotime.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>	<a781481a0707210136l272fc4fauaf14afce4178d9e4@mail.gmail.com>	<6bffcb0e0707210900h505f04aaq98e0f4b17139d94b@mail.gmail.com>	<200707211841.39339.ak@suse.de>	<6bffcb0e0707211111g32684615k5d526be182b53cc@mail.gmail.com> <20070721121310.361fe9cc.akpm@linux-foundation.org>
In-Reply-To: <20070721121310.361fe9cc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pisze:
> On Sat, 21 Jul 2007 20:11:16 +0200 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> Yet another one:
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/00004.jpg
>> it looks very weird ;)
>>
>> Why "Linux 2/6/22-git14 #14 SMP..." banner is displayed 5 times?
> 
> Was that with the fixed x86_64-mm-i386-string-out-of-line.patch?

Yes
+
modified series applied on top of 2.6.22-git14

--- series      2007-07-20 09:21:49.000000000 +0200
+++ linux-work2/series  2007-07-21 18:54:43.000000000 +0200
@@ -1,4 +1,4 @@
-origin.patch
+#origin.patch
 slow-down-printk-during-boot.patch
 slow-down-printk-during-boot-fix-2.patch
 xen-disable-vdso-nosegneg-on-native-boot.patch
@@ -131,6 +131,7 @@ libata-send-event-when-an-received.patch
 ata-ahci-alpm-store-interrupt-value.patch
 ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
 ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
+ata-ahci-alpm-enable-link-power-management-for-ata-drivers-fix.patch
 ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
 #
 # experimental:
@@ -362,7 +363,8 @@ x86_64-mm-define-and-use-local_distance-
 x86_64-mm-acpi-various-cleanups.patch
 x86_64-mm-fam10-string.patch
 x86_64-mm-gcc43-memcpy.patch
-x86_64-mm-i386-string-out-of-line.patch
+#x86_64-mm-i386-string-out-of-line.patch
+i386-string-out-of-line
 x86_64-mm-gcc-hot-cold.patch
 x86_64-mm-vdso.patch
 x86_64-mm-tsc-unstable.patch
@@ -532,8 +534,8 @@ i386-remove-unnecessary-code.patch
 git-newsetup.patch
 #
 #
-git-xfs.patch
-git-xfs-fixup.patch
+#git-xfs.patch
+#git-xfs-fixup.patch
 #git-cryptodev.patch
 #git-cryptodev-fixup.patch
 #git-xtensa.patch
@@ -542,7 +544,7 @@ xtensa-enable-arbitary-tty-speed-setting
 #pci-device-ensure-sysdata-initialised-v2.patch
 git-kgdb.patch
 git-kgdb-fixup-2.patch
-mm.patch
+#mm.patch
 #
 pci-x-pci-express-read-control-interfaces-myrinet.patch
 pci-x-pci-express-read-control-interfaces-mthca.patch

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
