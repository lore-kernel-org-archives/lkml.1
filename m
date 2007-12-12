Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbXLLMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbXLLMDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXLLMDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:03:08 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39768 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751899AbXLLMDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:03:07 -0500
Date: Wed, 12 Dec 2007 13:03:09 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Shane <gnome42@gmail.com>, Brandon Philips <brandon@ifup.org>,
       linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
Subject: Re: 2.6.24-rc5 "videobuf_read_start"
	[drivers/media/video/videobuf-dvb.ko] undefined!
Message-ID: <20071212120308.GG14204@stusta.de>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com> <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1197457394.4807.40.camel@gaivota>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 09:03:14AM -0200, Mauro Carvalho Chehab wrote:
>...
> I'm afraid that this wouldn't avoid this bug, however. 
> 
> The removal of the EXPORT_SYMBOL_GPL seemed to be the intention of
> Brandon, since he renamed the function, removing the locks. I think he
> didn't noticed that videobuf_dvb were using videobuf_read_start. The
> patch I've just send fixes it properly.

At least in the commit in Linus' tree, videobuf_read_start() stayed 
nearly unchanged.

> Btw, Shane patch reveals a small trouble with EXPORT_SYMBOL_GPL: adding
> the tag for a non-existing function didn't rise any error.

See above.

> IMO, it
> should generate some compilation error, if you try to export a symbol
> that doesn't exist at the file that is being compiled.

It does give you a compile error when there's not at least a prototype 
for the stuff to be exported, and a link error if there's no
variable/function.

> Cheers,
> Mauro

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

