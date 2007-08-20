Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbXHTGGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbXHTGGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 02:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXHTGG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 02:06:27 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:14382 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXHTGG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 02:06:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=krY/cmB/+HF5cb1Rp5jbsmXuifUD/RXxhEmuTHeT7caemDcRQnnI3VxMeq9eKG0Oe3aXBx47NhqBFP9o4oMQGwuwGSirCbn2rNkTU/qUGfa6h28ks1A7fnBtbldFG1UmVYiZd0IfUeSa9CHM2XlXuuH0QSA0XkLmhKV4ByjoW1c=
Message-ID: <d970ff420708192306gfe0628dn192f01e8301f2b39@mail.gmail.com>
Date: Mon, 20 Aug 2007 03:06:25 -0300
From: Alemao <xcarandiru@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: usb & udev
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When I plug my board with the FT232R chip from FTDI (USB to serial) a
module named usbserial.ko and ftdi_sio.ko is inserted automatically.

I saw in udev rules that this is the line responsible for doing that:

# Load drivers that match kernel-supplied alias
ENV{MODALIAS}=="?*",                    RUN+="/sbin/modprobe -Q $env{MODALIAS}"

What I want to know is who send this for udev? usbcore module?

The variable $env{MODALIAS} is something like this:

                 usb:v0403p6001d0600dc00dsc00dp00icFFiscFFipFF

v0403 is the vendor ID, p6001 is the product ID, but the others? I
didnt find anything about this in modprobe or udev docs....

Thanks,

-- 
Alemao
