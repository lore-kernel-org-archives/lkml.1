Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbZJEMzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbZJEMzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZJEMzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:55:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZJEMzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:55:00 -0400
Date: Mon, 5 Oct 2009 09:53:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?ISO-8859-1?B?ROpuaXM=?= Goes <denishark@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: TM6010 driver and firmware
Message-ID: <20091005095343.6b9afa65@pedra.chehab.org>
In-Reply-To: <f326ee1a0910030602w2518f66q2d6e185c473d5ad@mail.gmail.com>
References: <f326ee1a0910030539pd5e00e2xb9f6de9975b64b9b@mail.gmail.com>
	<f326ee1a0910030602w2518f66q2d6e185c473d5ad@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dênis,

Em Sat, 3 Oct 2009 10:02:26 -0300
Dênis Goes <denishark@gmail.com> escreveu:

> Hi People...
> 
> I'm a programmer and I want to help in development of tm6010 driver to
> finish the driver and use my PixelView 405 USB card.
> 
> What the status of tm6010 driver ??? How to obtain the correct tridvid.sys
> file ??? I have here 7 file versions from many driver versions, but none
> have the correct md5sum.

Probably it will use v2.7 firmware or v3.6 (if it has a xc3028L). Those firmwares
are available via Documentation/video4linux/extract_xc3028.pl script. The instructions
for use it are commented on the top of the script file.

The driver is at the staging directory at the mercurial tree. It compiles fine, but
it generates some OOPSes when you try to use it. It may be related to the i2c
conversion or to the buffer filling routines.

Feel free to contribute. While I want to finish the driver, due to some higher
priority tasks on my large TODO list, it is unlikely that I'll have some time
for doing it soon, unfortunately.



Cheers,
Mauro
