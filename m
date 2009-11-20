Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZKTHA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZKTHA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZKTHA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:00:27 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:51751 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZKTHAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r3jYmS0kdMKYt0WszQxvzj+KnQcojvBKkMWo3bPKlVWhzbMYm/HeR+Ff03B7TkgWqB
         /I/GMZXeXeRz/qxw9+QVBtMUX9h+OOPmZMLu5mHRziOfp5ijyGiGOPl8Z9nX6jSa/1XT
         VK5uvTekA6pqZR0k+/gcILiH+Km2fqx2+sAr4=
MIME-Version: 1.0
In-Reply-To: <1258656557-5492-1-git-send-email-linus.walleij@stericsson.com>
References: <1258656557-5492-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 20 Nov 2009 00:00:31 -0700
X-Google-Sender-Auth: f14885d6bf9b5804
Message-ID: <e9c3a7c20911192300q6f1c9361j87617fcf2f2a4118@mail.gmail.com>
Subject: Re: [PATCH] Add COH 901 318 DMA block driver v5
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 11:49 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
> found in the U300 series platforms. It registers a DMA slave for
> device I/O and also a memcpy slave for memcpy.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> ChangeLog v4->v5
> - Change requested DMA pool memory type from GFP_ATOMIC to
>  GFP_NOWAIT
> - Remove the prep_interrupt function altogether, inline it
>  in the few places needed, simplifying the code overall.
> - implement the .is_tx_complete() function.
> ---

Applied to the 'next' branch of async_tx.git.

Thanks,
Dan
