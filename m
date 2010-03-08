Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0CHQQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:16:04 -0500
Received: from mail.perches.com ([173.55.12.10]:1506 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab0CHQQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:16:01 -0500
Subject: Re: drivers/net/mac8390.c: Remove useless memcpy casting
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <10f740e81003070119s3eb433d9r4f1cc79e59d56316@mail.gmail.com>
References: <201003022001.o22K16vJ011337@hera.kernel.org>
	 <10f740e81003070119s3eb433d9r4f1cc79e59d56316@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 08:16:00 -0800
Message-ID: <1268064960.1925.19.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-07 at 10:19 +0100, Geert Uytterhoeven wrote:
> ... hence you introduced 3 compiler warnings:
> 
> drivers/net/mac8390.c:249: warning: passing argument 1 of
> '__builtin_memcpy' makes pointer from integer without a cast
> drivers/net/mac8390.c:254: warning: passing argument 1 of
> 'word_memcpy_tocard' makes pointer from integer without a cast
> drivers/net/mac8390.c:256: warning: passing argument 2 of
> 'word_memcpy_fromcard' makes pointer from integer without a cast

Thanks, I'll submit a patch to fix it by tomorrow or so.

