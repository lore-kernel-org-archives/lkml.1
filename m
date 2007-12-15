Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbXLOMmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbXLOMmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 07:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXLOMmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 07:42:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262AbXLOMmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:42:06 -0500
Date: Sat, 15 Dec 2007 04:41:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc5-mm1 -- drivers/video/logo/logo_linux_clut224.c:598:
 error: conflicting type qualifiers for =?UTF-8?B?4oCYbG9nb19saW51eF9jbHV0?=
 =?UTF-8?B?MjI04oCZ?=
Message-Id: <20071215044123.9e7bc160.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0712131716n39d29ec4qa0dfd6ad64a50b0a@mail.gmail.com>
References: <a44ae5cd0712131716n39d29ec4qa0dfd6ad64a50b0a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 20:16:13 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> Content analysis details:   (2.2 points, 2.0 required)
> 
>  pts rule name              description
> ---- ---------------------- --------------------------------------------------
>  3.1 UNIQUE_WORDS           BODY: Message body has many words used only once
>  0.3 UPPERCASE_50_75        message body is 50-75% uppercase
> -1.3 AWL                    AWL: From: address is in the auto white-list
> 

hm, look who I found in my spam folder.

> 
> 
> From: "Miles Lane" <miles.lane@gmail.com>
> To: "Marcin Slusarz" <marcin.slusarz@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
> Subject: 2.6.24-rc5-mm1 -- drivers/video/logo/logo_linux_clut224.c:598: error: conflicting type qualifiers for ‘logo_linux_clut224’
> Date: 	Thu, 13 Dec 2007 20:16:13 -0500
> Sender: linux-kernel-owner@vger.kernel.org
> 
>   CC      drivers/video/logo/logo_linux_clut224.o
> drivers/video/logo/logo_linux_clut224.c:598: error: conflicting type
> qualifiers for 'logo_linux_clut224'
> include/linux/linux_logo.h:47: error: previous declaration of
> 'logo_linux_clut224' was here
> make[3]: *** [drivers/video/logo/logo_linux_clut224.o] Error 1

Yeah, `make mrproper' is needed.  A `make clean' might work too - I haven't
tried that.
