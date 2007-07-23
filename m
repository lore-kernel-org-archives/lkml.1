Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbXGWBXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbXGWBXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXGWBXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:23:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:15750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXGWBXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SDim/icjFepjTsOyQQWDNeJPTS2vb4Hkn3xRoZLj3CmjDpoZqdpz8xwuExzzVhRiC4/EocXdzQ82tmljhGqM2ipKzr2/b1H+PfgxjKijJ5CR8qwY09bhI2w2tY06daFnKTBq3fWUObhqqABHUjrnswc2dvaYZPHltkQNeAiEjp0=
Message-ID: <46A4027A.5060802@googlemail.com>
Date: Mon, 23 Jul 2007 03:20:58 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       corentincj@iksaif.net
Subject: Re: Linus 2.6.23-rc1
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Ok, right on time, two weeks afetr 2.6.22, there's a 2.6.23-rc1 out there.
> 

allmodconfig is broken

...

drivers/misc/asus-laptop.c: In function 'asus_led_exit':
drivers/misc/asus-laptop.c:1076: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1076: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1077: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1077: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1078: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1078: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1079: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1079: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1080: error: 'struct led_classdev' has no member named 'class_dev'
drivers/misc/asus-laptop.c:1080: error: 'struct led_classdev' has no member named 'class_dev'
make[2]: *** [drivers/misc/asus-laptop.o] Error 1
make[2]: *** Waiting for unfinished jobs....


...


Regards,

Gabriel C
