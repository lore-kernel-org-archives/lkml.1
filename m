Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXHVAzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXHVAzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXHVAza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:55:30 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:46099 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbXHVAz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wx6JHVuf3fw1HvGRT4ub+0tOlIj8wRNf8AybRLyO2z1mSJL4SAH5ueROqMXpPV7d8JtWRSMkx0UCBmT3BelxEuPvBswoIo1pBE/IFy5k2QhCA800uImgNaiYdVygcRGzgCFubKZC6jB0dfzX6bBtc3xY5r1NjqSgroDdeFDPgig=
Message-ID: <5dc6fd9e0708211755lbaa897as5ec95d969441a9a5@mail.gmail.com>
Date: Tue, 21 Aug 2007 17:55:28 -0700
From: "Hex Star" <hexstar@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <5dc6fd9e0708211303h235256b2ra71c2025f101478@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
	 <5dc6fd9e0708211226k3f931579x6f8b3ab275f93c35@mail.gmail.com>
	 <5dc6fd9e0708211227k22f9e214vd8132913214716b3@mail.gmail.com>
	 <200708212256.59281.ismail@pardus.org.tr>
	 <Pine.LNX.4.64.0708212157530.20435@fbirervta.pbzchgretzou.qr>
	 <5dc6fd9e0708211303h235256b2ra71c2025f101478@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I resolved the issue like so:

1) Download kernel source (K) from kernel.org

2) move the archive to a place where source is, /home/user/linux for
example (will have to do mkdir /home/user/linux first of course!) via
mv /home/user/Desktop/archive /dest/archive

3) Extract the archive: if .tar.bz2: tar -jxvf archive.tar.bz2 else
tar -zxvf archive.tar.gz

4) cd into resulting directory

5) do a sudo make defconfig, then sudo make xconfig (or if in terminal
menuconfig) and customize options for system, filesystem and
controller support must be built in!

6) do a sudo make

7) then sudo make modules_install

8) then sudo make install

9) then do a sudo update-initramfs -k kernelversion -c -v

10) then grub-update

11) reboot and enjoy!
