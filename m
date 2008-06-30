Return-Path: <linux-kernel-owner+w=401wt.eu-S1764354AbYF3Tys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764354AbYF3Tys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762107AbYF3Tyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:54:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:55695 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYF3Tyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x2sVGF/IReWASiKqt7nIGznUXtO1qPPRkp8ibbfxub2lvSllH7ZZe1j65lkqQqVPy5
         Yo20KQO7Tk65j32pFP6d2foXPjDmI7kGs8Fv7S/pXmdnDieJtcHVO903jh25Jpz4yfEp
         H43ILQCd5D66tmjV66zjmh1Ey+uaYGjP7HTuo=
Message-ID: <4869396B.8060401@gmail.com>
Date: Mon, 30 Jun 2008 21:52:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: JosephChan@via.com.tw
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, geert@linux-m68k.org
Subject: Re: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7804@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7804@exchtp03.taipei.via.com.tw>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff -Nur a/drivers/video/via/ioctl.h b/drivers/video/via/ioctl.h
> --- a/drivers/video/via/ioctl.h	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/ioctl.h	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,212 @@
[...]
> +struct device_t {
> +	unsigned short crt:1;
> +	unsigned short dvi:1;
> +	unsigned short lcd:1;
> +	unsigned short samm:1;
> +	unsigned short primary_dev;
> +
> +	unsigned short lcd_dsp_cent:1;
> +	unsigned char lcd_panel_id;
> +	unsigned char lcd_mode:1;
> +
> +	unsigned short xres, yres;
> +	unsigned short xres1, yres1;
> +	unsigned short refresh;
> +	unsigned short bpp;
> +	unsigned short refresh1;
> +	unsigned short bpp1;
> +	unsigned short sequence;
> +
> +	unsigned short epia_dvi:1;
> +	unsigned short lcd_dual_edge:1;
> +	unsigned short bus_width;
> +	unsigned short lcd2:1;
> +};

Bitfields suck (and generate ugly code).
