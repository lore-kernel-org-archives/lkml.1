Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYIQEuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYIQEuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 00:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYIQEuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 00:50:07 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:48864 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYIQEuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 00:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=EM46794BlRBLYhK0y/isGNPFcDK7y55yN1X7zRjOlsXItkKSOJe6D3vv39spHzKASi
         JAfjS4cEzfzz2gqC7SRzJaP1FKNdQpmKtxXCUnnbum4Gz8ZoQVzbKhAs3HpuifSks3Kd
         agqCe2PmnedZKUFvrVAm0hCVWii0wFVEsMUwk=
Message-ID: <76366b180809162150o51701a1fk209af4e84ffc5674@mail.gmail.com>
Date: Wed, 17 Sep 2008 00:50:03 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ACPI "Soft-off" power button only rebooting system, not powering off
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c4186d0547644979
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an AMD / Award BIOS based system which does not properly shut
off when I hold down the power button for 4 seconds. The BIOS is
configured to have "Soft-off" set to "Delay for 4 seconds" which is
supposed to power the machine off if the button is held that long.

I first thought this could be a BIOS bug, but this *only* appears to
happen while Linux is running. If the computer is running WinXP, it
works fine. Also, if I hold down the button for 4 seconds while the
BIOS is in POST, it also works fine. If the kernel has booted, even if
the kernel is not running anymore due to a `halt`, holding the button
down merely reboots the PC after 4 seconds.

Can anyone offer a place to start poking around to see why this only
happens when Linux is running? Would this have to do with the ACPI
code itself? The kernel version does not seem to matter. I first
noticed this on stock Debian 2.6.18-4, and I just reproduced it right
now using 2.6.26.5.

Thanks,
-Andrew
