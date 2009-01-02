Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZABGkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZABGkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 01:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZABGk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 01:40:26 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55023 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZABGk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 01:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=CWuIFFMvjc/tqJcm3eHun1Xpm6hBWL+TJEJhfIjbhmadqMe0ulJklEedPl7houHPQs
         OSFttesf4FK0jgDpNH0GbHpm7Mc7Y0h4QfG08C4Vzf2SCglFDsUsLx2LgTYpJWrNLi6R
         xyGFgwRhIoN6F0yoKr3hkALzgR6xGkmDkwYME=
Message-ID: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com>
Date: Fri, 2 Jan 2009 12:05:05 +0530
From: "Sriram V" <vshrirama@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Power Management with rootfs on SDMMC.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I am using linux-2.6.27.  I am testing power management after
booting out of a SD/MMC card.
  My root file system is on a SD card.

  I am issuing the following command to suspend

      $ echo -n mem > /sys/power/state

 What happens is, The kernel hangs and it does not come out of suspend.
 even after i press keypad/generate serial input data.

 # echo -n mem > /sys/power/state
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
mmc0: card e624 removed
--- kernel hangs---

The same works, If i boot on NFS and mount a SD card.
PM works, suspend and resume work fine. This means
that the PM of SD MMC driver works properly.

However, I have a problem when the rootfs is on SDMMC card.
Has anyone tried this before?

Am i missing something here?

Regards,
sriram
