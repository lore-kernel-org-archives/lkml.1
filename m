Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbXI1RP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbXI1RP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXI1RPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:15:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:13262 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXI1RPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Zp7nn08Zfx9GfjFsfcpeUaklCU2T2jEhFGq0RuweNZN44sJEZKObJSPS7Pz+3820XNCMKn8luPfJ2WAlYt3F+Nwkisw9rBS2ZBeYMxSU/Lub7n1L6EhT3ibMM+1EJjkinuLPQFxUXhI7Kr087U1G1TVFVPDNzzloUVBVRXGhvX0=
Message-ID: <dd4eba420709281015w50bd6b0fj21f72756a962a26b@mail.gmail.com>
Date: Fri, 28 Sep 2007 21:15:11 +0400
From: "Sergey Popov" <faijeya@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: General slowness with using 64Gb HIGHMEM option on 32-bit kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Short description: after recompiling 32-bit kernel with 64Gb highmem
support and rebooting into it, OS started working very much slower
then before.

Specifications: Intel Core 2 Duo E6600@2,4Ghz on Intel i965Q-based
motherboard. 6Gb of DDR2 RAM, 2x1Gb+2x2Gb, dual-channel.
Vector Linux 5.8 (Slackware Linux 11-based), 2.6.20.3 kernel.

Long description: after recompiling 32-bit 2.6.20.3 kernel with 64Gb
highmem option and rebooting into it, booting process froze on udevd.
After booting up from CD and disabling rc.udev, system started, but
it's work after rc.M script sarted was 5-10 times slower then usual.
top showed, that processes are taking much more CPU% time then usual.
I tried downloading the newest stable kernel - 2.6.22.9 - hoping, that
it would solve the problem. I downloaded it, booted from CD, and
compiled it with 64Gb highmem support. I felt some speed improvement,
but if on 2.6.20.3 machine performed like P166, now it is working like
P2-350.
I've found a similar problem, described on lkml -
http://lkml.org/lkml/2007/5/30/5 . But, unfortunately, it is x86_64
related and contains no clues for me.

Moving to 64-bit distro is rather unpleasant - as there is an option
in 32-bit kernel, it should work ;) .

What tests should I run to help investigate this problem?
