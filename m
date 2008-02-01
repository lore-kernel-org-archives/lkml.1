Return-Path: <linux-kernel-owner+w=401wt.eu-S935477AbYBAFDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935477AbYBAFDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764982AbYBAE4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:56:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935093AbYBAE4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:56:14 -0500
Message-ID: <47A2A504.6060108@zytor.com>
Date: Thu, 31 Jan 2008 20:50:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Reinaldo Carvalho <reinaldow@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: missing asm-x86_64 detection
References: <ec36785a0801311513g4172b915w7bdb7ca97035efde@mail.gmail.com>
In-Reply-To: <ec36785a0801311513g4172b915w7bdb7ca97035efde@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reinaldo Carvalho wrote:
> :/# uname -a
> Linux devil 2.6.22.16-amd64 #15 SMP Sat Jan 19 13:58:02 BRT 2008
> x86_64 GNU/Linux
> 
> :/# cd /usr/src/linux-2.6.22
> :/# patch -p1 -R < ../patch-2.6.22.16
> :/# patch -p1 < ../patch-2.6.23
> :/# patch -p1 < ../patch-2.6.24
> :/# cd /usr/src/ ; mv linux-2.6.22 linux-2.6.24; cd linux-2.6.24
> :/usr/src/linux-2.6.24# make oldconfig
> :/usr/src/linux-2.6.24# make all
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
> ERROR: the symlink include/asm points to asm-x86_64 but asm-x86 was expected
>        set ARCH or save .config and run 'make mrproper' to fix it
> make: ** [include/asm] Erro 1
> 

"make mrproper" please.

	-hpa
