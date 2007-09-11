Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbXIKF0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbXIKF0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbXIKF0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:26:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:53539 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbXIKF0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dL+Fx7t0Z4EyXEQ+vkILkL8fiZKVHGeV945PbxEPVI/UtrLzzJJA85YegTtnLuoPLpyCcH0XIoulR7zsfKEgYyA4g50oMiWaZFe8+TtJ2Een1UJk14blUp8tl8cvaor/qfY7/pg9TftlxAZiY06qn29cin0HYJr9+4+OQbkEoo8=
Message-ID: <d120d5000709102225n516d9c17m2120b64cef801625@mail.gmail.com>
Date: Tue, 11 Sep 2007 01:25:58 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Subject: Re: [PATCH 2/2] Maple bus support for the SEGA Dreamcast - Dreamcast keyboard support
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
In-Reply-To: <8b67d60709101617n564daf28s83212469d879d00d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60709101617n564daf28s83212469d879d00d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/07, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> +
> +	for (i = 0; i < NR_SCANCODES; i++)
> +		memcpy(kbd->keycode + i * sizeof(unsigned char), dc_kbd_keycode + i
> * sizeof(unsigned char),
> +				 sizeof(unsigned char));

Ahem... That's not what I had in mind when I asked for memcpy. How about:

        memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode);

?

Thanks.

-- 
Dmitry
