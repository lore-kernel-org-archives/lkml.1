Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXIEJnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXIEJnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbXIEJnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:43:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52653 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbXIEJnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:43:16 -0400
Date: Wed, 5 Sep 2007 11:43:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: building a specific in-tree module is currently a bit broken
In-Reply-To: <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain>
 <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5 2007 11:37, Michal Piotrowski wrote:
>
>Hi,
>
>[Adding K{build,config} wizards to CC]
>
>On 05/09/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>>
>> $ make distclean
>> $ make defconfig
>> $ make menuconfig      (select visor.ko to be built a module)
>> $ make drivers/usb/serial/visor.ko

Beep. Need 'make scripts prepare' between menuconfig and visor.

Also note that visor will not have any symvers until you have
a Module.symvers (which, ironically, is created at the end of "make vmlinux")



	Jan
-- 
