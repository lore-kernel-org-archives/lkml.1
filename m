Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXF0HgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXF0HgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXF0HgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:36:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbXF0HgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:36:11 -0400
Date: Wed, 27 Jun 2007 00:35:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-usb-devel@lists.sourceforge.net,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Export usb_gadgetfs.h to userspace
Message-Id: <20070627003538.f15bef21.akpm@linux-foundation.org>
In-Reply-To: <11827637791662-git-send-email-hskinnemoen@atmel.com>
References: <11827637791662-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 11:29:39 +0200 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> The gadgetfs test program from http://www.linux-usb.org/gadget/
> depends on it. I assume most other users of gadgetfs needs this header
> too.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  include/linux/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index f317c27..b216ee3 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -152,6 +152,7 @@ header-y += tipc.h
>  header-y += toshiba.h
>  header-y += ultrasound.h
>  header-y += un.h
> +header-y += usb_gadgetfs.h
>  header-y += utime.h
>  header-y += video_decoder.h
>  header-y += video_encoder.h

`make headers_check' fails:

make[2]: *** No rule to make target `/usr/src/devel/include/linux/usb_gadgetfs.h', needed by `/usr/src/devel/usr/include/linux/usb_gadgetfs.h'.  Stop.

