Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069Ab0ANPHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab0ANPHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043Ab0ANPHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:07:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:62567 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab0ANPH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:07:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fw28y5i0bNE4URJQyOTqy4/vha4mc31U3V1fvp4FuktaIkf3JxoCZmMCPiqsjUiC+6
         qJ0pxBHdxar+97TtzLAHJIU7OWpzP6D4c9NGUNQSBRspIeWwxxSj7tPkkG54PJsppfcT
         x8Rn4pYJ/1VcvEKRfm2Up/ETbzMC66wsJz/6E=
MIME-Version: 1.0
In-Reply-To: <1263319113-6631-3-git-send-email-tiago.vignatti@nokia.com>
References: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
	 <1263319113-6631-2-git-send-email-tiago.vignatti@nokia.com>
	 <1263319113-6631-3-git-send-email-tiago.vignatti@nokia.com>
Date: Thu, 14 Jan 2010 13:07:26 -0200
Message-ID: <8944b161001140707k48387591qabacdb51541a5b6f@mail.gmail.com>
Subject: Re: [PATCH-again] vgaarb: use MIT license
From: Paulo Zanoni <przanoni@gmail.com>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Henry Zhao <Henry.Zhao@sun.com>,
       Andy Getzendanner <james.getzendanner@students.olin.edu>,
       Brad Spengler <spender@grsecurity.net>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 3:58 PM, Tiago Vignatti
<tiago.vignatti@nokia.com> wrote:
> Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
Signed-off-by: Paulo R. Zanoni <przanoni@gmail.com>

> ---
> Hi. All authors already decided about such change. So I'd please ask (again)
> that you put the s-o-b tag here. Thanks.
>
>  drivers/gpu/vga/vgaarb.c |   26 +++++++++++++++++++++++---
>  include/linux/vgaarb.h   |   21 +++++++++++++++++++++
>  2 files changed, 44 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index 0f5f64d..53dd628 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -1,12 +1,32 @@
>  /*
> - * vgaarb.c
> + * vgaarb.c: Implements the VGA arbitration. For details refer to
> + * Documentation/vgaarbiter.txt
> + *
>  *
>  * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
>  * (C) Copyright 2007, 2009 Tiago Vignatti <vignatti@freedesktop.org>
>  *
> - * Implements the VGA arbitration. For details refer to
> - * Documentation/vgaarbiter.txt
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the next
> + * paragraph) shall be included in all copies or substantial portions of the
> + * Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS
> + * IN THE SOFTWARE.
> + *
>  */
>
>  #include <linux/module.h>
> diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
> index 2dfaa29..c9a9759 100644
> --- a/include/linux/vgaarb.h
> +++ b/include/linux/vgaarb.h
> @@ -5,6 +5,27 @@
>  * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
>  * (C) Copyright 2007, 2009 Tiago Vignatti <vignatti@freedesktop.org>
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the next
> + * paragraph) shall be included in all copies or substantial portions of the
> + * Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS
> + * IN THE SOFTWARE.
> + *
>  */
>
>  #ifndef LINUX_VGA_H
> --
> 1.6.0.4
>
>



-- 
Paulo R. Zanoni
