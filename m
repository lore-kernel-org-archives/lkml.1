Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYIVUeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYIVUeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYIVUeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:34:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:21957 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYIVUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=itXbzJWS76ivshj4gTSUXg9cMsZGRTn4f5WAQrzSR23yqKagRS81PJf7vtVwgYD/50
         0LpoB2egJ7m9pA96FJ4Wr4uNfS4dySVL9id3KhMvDYjagOR3mBaQOsVkB9KNZkNZeSS6
         2G/JhFfs5ZI+/qutldPrnaIrmvv1boAbnKFyo=
Message-ID: <5d9b736f0809221334i773a500eu5ff61884729a4367@mail.gmail.com>
Date: Mon, 22 Sep 2008 22:34:14 +0200
From: "Michal Januszewski" <michalj@gmail.com>
To: "Krzysztof Helt" <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] fbdev: don't allow to set a video mode via vga= if FB doesn't support it
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20080922214747.c8bc57eb.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080921210219.GC21215@spock.one.pl>
	 <20080922214747.c8bc57eb.krzysztof.h1@poczta.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 21:47, Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> This one could be simpler:
>
>                /* It's a supported text mode */
>                is_graphic = 0;
>  +#if FB_SUPPORTS_BOOT_VESA
>        } else if ((vminfo.mode_attr & 0x99) == 0x99) {
>                /* It's a graphics mode with linear frame buffer */
>                is_graphic = 1;
>                vesa_mode |= 0x4000; /* Request linear frame buffer */
>  +#endif
>        } else {
>                return -1;      /* Invalid mode */
>        }

Agreed.

I'll wait at least one more day for any additional comments and repost
a fixed version.

Thanks for doing the code review.
-- 
Michal Januszewski, Gentoo Linux Developer
http://people.gentoo.org/spock
