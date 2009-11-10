Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZKJX2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZKJX2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbZKJX2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:28:06 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:56167 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbZKJX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:28:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=p/9Mfo9HxayE9qEW1tRzVWeGivz8bRApn/QKyF9MJ14WU/JtHEAR9xhrj5TahCBZ8L
         uejrioR8W7C/FxV5OMPWpMSiknDTizz0RFx9bbDj77v21rzdkhWiFtTeEbi1PKvHNc84
         5Jnh7oTssMMvM3tCRsuw0Y5hIpPZkSfgUmT9U=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 15:27:50 -0800
Message-ID: <43e72e890911101527s6d29b35cuaf63e081762c1eb7@mail.gmail.com>
Subject: Oops on i915 on 8086:a011 pine trail 2.6.32-rc6
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting an oops with a pine trail netbook I'm doing testing on on
2.6.32-rc6 with a fresh new distro kernel for the next Ubuntu 10.04
release:

https://launchpad.net/ubuntu/+source/linux/2.6.32-3.3/+build/1339939/+files/linux-image-2.6.32-3-386_2.6.32-3.3_i386.deb

The machine boots fine with 2.6.31.

The oops happens early on the boot process, I'll next rebuild my own
with early boot delay (CONFIG_BOOT_PRINTK_DELAY) as that seems to be
the only way I'm going to get this full trace out. Good thing is its
100% reproducible so I should be able to bisect. The only thing
visible so far is the end of the oops:

http://bombadil.infradead.org/~mcgrof/oops-img/2009/11/2.6.32-rc6-i915-8086-a011-oops-01.jpg

PS. who maintains i915? I see no entry for it on MAINTAINERS and it
took me a while to find the intel-gfx@lists.freedesktop.org (only
member posting) list. Is this the right list?

  Luis
