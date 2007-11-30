Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXK3SKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXK3SKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933035AbXK3SJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:09:56 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56756 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003AbXK3SJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:09:55 -0500
Date: Fri, 30 Nov 2007 19:09:54 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: RFC - organize include/linux/kernel.h, add include/linux/logging.h
In-Reply-To: <1196445871.22120.178.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711301908430.18767@fbirervta.pbzchgretzou.qr>
References: <20071130092842.GA6221@localhost.sw.ru> <1196445871.22120.178.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 30 2007 10:04, Joe Perches wrote:
>
>There are many private logging definitions that could be
>consolidated in generic way.  Things like:
>
>	#define MY_PRINTK(fmt, arg) print(PFX fmt, ##arg)
>
>cheers, Joe

While you are at that, PFX should probably be KBUILD_MODNAME,
for simplicity. Then it will be easy to consolidate since
they all use KBUILD_MODNAME rather than their own PFX.
Just btw :)

