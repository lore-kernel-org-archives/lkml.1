Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbXF0PNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbXF0PNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbXF0PND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:13:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:46887 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169AbXF0PNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iQx0kjEh/K6XChRdKQUjEzV/alYLwc/la7qoF6TfDwEM3CRLkEsVV7JNHXzpxqgOM/jktBQFFYZ8WLtAINcov6uSYAP7otYDdv35kjp3W3Qi+SIZ7RKt8jNawEl8u+UBtEuCw2C8R07qH2YDjUGKKBuuMS/isVYNdfHbCZr/DK0=
Message-ID: <69ff73b20706270812m3a9e0615g795531f9b23ee52e@mail.gmail.com>
Date: Wed, 27 Jun 2007 11:12:59 -0400
From: "Martin Owens" <doctormo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Passive port support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been pondering and searching for answers on the level of support
currently in linux for  passive port devices (serial, parallel, vga
etc) for some time wondering if it's time we looking at integrating
user selectable or identifiable components through the standard device
paths we currently use for pci/usb/iee1394; at the moment the onus is
on driver modules or user land programs to communicate, identify,
select and manage all devices connected in this way with no methods to
let the kernel know what has been identified, no standard way to tag
passive devices with ids or models (thus no way to have modules load
on selection, or identifiable strings in device managers etc)

This amounts to a virtual plug (the user or detection/probe software
tells the kernel what is plugged in rather than the hardware)

I'm proposing a small kernel manager which handles identified passive
ports and what has been identified as plugged into them (hopefully so
that the state lasts a reboot) and it may also be good to have a way
for passive ports to be registered (for instance graphics card vga)
but that's not the most important since xorg handles all that quite
well these days.

Once such support exists I can foresee simple gui and cli tools that
allow users to probe or select devices for such ports in a standard
way; even for ports that I am currently unaware of.

One point against doing this is that such devices are now quite old
and most new things are usb anyway. but I still see people struggle
with the odd bit of old hardware, printer etc.

Overview:

User Selection -> Kernel Registered -> Normal module autoloads /
automounts, udev etc

Please do CC me back in any replies, and er forgive me if I'm posting
incorrectly; I've asked around a LOT weather it's a valid
question/suggestion.

Best Regards, Martin Owens
