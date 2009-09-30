Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZI3RYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZI3RYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZI3RYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:24:33 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:58363 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZI3RYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:24:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=CjC8gHlOm5cgH6w5Mx81F4oYmc8SGE1QLOyokb3c5vRslCLUEG/5ajAKxfEjEIp3;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <12591585.1254331476737.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Wed, 30 Sep 2009 13:24:36 -0400 (EDT)
From: "Steven A. DuChene" <linux-clusters@mindspring.com>
Reply-To: "Steven A. DuChene" <linux-clusters@mindspring.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Warning: unable to open an initial console
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: ea4808abc3da2865808dd114cae72f675e89bb4777695beb00ff6c36d42eb1faa8c7f237ba6df29433c387c9bad7bd09350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, according to the research I did looking for my initial
console error message on google it seems it is not a kernel
compile issue but rather an issue with the kernel needing to
find /dev/console before udev is run to create the various
device entries in /dev

To work around this I created an initrd file for my kernel
even though I have all the needed disk device drivers and
filesystems drivers in my kernel. Once I did that and put
it into place my new kernel booted up just fine.

-----Original Message-----
>From: "Steven A. DuChene" <linux-clusters@mindspring.com>
>Sent: Sep 30, 2009 1:05 PM
>To: linux-kernel@vger.kernel.org
>Subject: Warning: unable to open an initial console
>
>Hmm, I tried various combonations of turning off the framebuffer
>support all together and then turning it back on with various
>drivers (nvidia or vesa vga) but still I get the same message
>about "Warning: unable to open an initial console."
>
>Anything else I should be looking at besides the graphics support
>part of the drivers section of the kernel config?
>
>Again this is a fairly standard PCChips A13G motherboard with
>NVidia chipset and AMD Athlon 3600+ CPU that works fine with the
>regular distro supplied FC9 kernel (2.6.25-14.fc9.x86_64) and
>I have the x86_64 version of FC9 installed.
>



