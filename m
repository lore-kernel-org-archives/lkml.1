Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab0BDHct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:32:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843Ab0BDHco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:32:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] input: remove BKL from uinput open function
Date: Thu, 4 Feb 2010 08:32:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201001302257.09354.arnd@arndb.de> <520f0cf11002011518y22c2f097s87872e7b5b1690d7@mail.gmail.com> <20100203050749.GA22110@core.coreip.homeip.net>
In-Reply-To: <20100203050749.GA22110@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002040832.09805.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+tscfZtyO+WrnEuDEjpMObGBZGZdSit1uAL8Q
 4pEy287jbZ08bofts2CXQ9ZjTKKCzKzU8S+2W9MRB7FkQRNMGC
 zVLHuOQPZBrm0fuIRKVSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010, Dmitry Torokhov wrote:
> OK, so how about the patch below? If it is accepted I will just switch
> to
> 
>         nonseekable_open(inode, file);
>         return 0;
> 
> style. I gonna add Al and akpm to CC to see if the patch will stick...

Sounds reasonable, if only to prevent this from becoming a FAQ.

> VFS: clarify that nonseekable_open() will never fail
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Arnd Bergmann <arnd@arndb.de>
