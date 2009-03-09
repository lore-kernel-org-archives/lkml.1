Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZCIOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZCIOVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZCIOV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:21:28 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:61002 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZCIOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Yn0tDRDP8CjUZS+SVB/P7beKONC0fuTIxlgyBmJnxU9fTUpnQGWV+4GAw3AuLTJD0a
         8TcSOflCcxYd3C8xPsrAdKlYWrTE1bpG6VENJK6UKRc/OkCPAq6ONzvCAW82dBy81bqh
         /rKhwG+5pMt+V3g7edhexeIZ3+I9l04JAkHDQ=
MIME-Version: 1.0
Date: Mon, 9 Mar 2009 15:21:24 +0100
Message-ID: <2d05c4580903090721p2a6022base9e7dafa719e448e@mail.gmail.com>
Subject: Boot correct kernel
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had generic kernel 2.6.27-7 and it worked fine. Then I installed
2.6.28 that had errors during
install, but system anyway booted to 2.6.28. When I did apt-get
install of some app in this bad
2.6.28 kernel I got error messages that something is wrong. So I
entered boot menu and booted
to old 2.6.27-7 kernel and when I tried to do apt-get install of some
app, the system again looked at
2.6.28 like current kernel !!

So I looked where does files of current kernel are copied and there
are few folders (files):
/boot/vmlinuz*VERSION*
/boot/initrd*VERSION*
/boot/System-map*VERSION*
/boot/config-*VERSION*
/lib/modules
and also menu list in /boot/grub/menu.lst

So, when you have more kernels, let's say 4 working and one bad
kernel, when the system
boots selected kernel, should the system copy all files from selected
kernel to all places where
current running system kernel should be ?? That way you will always
have correct kernel running
whole system, and all installed modules for that kernel could be
loaded looking at modinfo of modules
or modules could be sorted into folders for each kernel version.

-- 
Thanks

Dragoslav Zaric
[Programmer ; M.Sc. in Astrophysics]
[Belgrade ; Serbia]
