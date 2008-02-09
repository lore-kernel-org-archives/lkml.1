Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYBIUNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYBIUNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 15:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYBIUNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 15:13:45 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45986 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbYBIUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 15:13:44 -0500
Date: Sat, 9 Feb 2008 21:13:43 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
cc: Ray Lee <ray-lk@madrabbit.org>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz
Subject: Re: how to tell i386 from x86-64 kernel
In-Reply-To: <20080201125350.04211519@Varda>
Message-ID: <Pine.LNX.4.64.0802092112510.6917@fbirervta.pbzchgretzou.qr>
References: <20080201004212.GA2818@elf.ucw.cz>
 <2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
 <Pine.LNX.4.64.0802010157370.4864@fbirervta.pbzchgretzou.qr>
 <20080201125350.04211519@Varda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 1 2008 12:53, Alejandro Riveira Fernández wrote:
>> 
>> # uname -m
>> I won't tell you.
>> # linux32 uname -m
>> i686
>
> Ubuntu 7.10 64 bit userland 2.6.24
>
>$ uname -m
>x86_64
>$ linux32 uname -m
>i686

What I am saying is that uname(2) does not reliably tell you whether you 
have a 64-bit kernel underneath unless you have other sources of 
information.
