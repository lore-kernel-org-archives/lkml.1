Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbXHFIVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbXHFIVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 04:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759858AbXHFIVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 04:21:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49201 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846AbXHFIVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 04:21:32 -0400
Date: Mon, 6 Aug 2007 10:21:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Nathan Williams <ngwilliams@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE usage
In-Reply-To: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708061013540.1735@fbirervta.pbzchgretzou.qr>
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 6 2007 17:53, Nathan Williams wrote:
>Hi,
>
>I'm working on a driver for an ADSL modem which requires the use of a
>binary library from the chipset manufacturer.  All my source code is
>GPL, [...]
>I've given permission for the binary library file to be used with the GPL
>source code and be re-distributed with it.
>
>Is it correct to say that my driver is licensed under GPL with
>additional rights to use the binary library file?

[ Obligatory IANAL sticker. ]

Clear case for me IMHO. If your code is GPL (and which you emphasize
with MODULE_LICENSE(GPL)) and then link in a binary blob, then the
combined work becomes GPL, and you are required to hand out sources for
it, including for the blob.

I won't mention the gray possibilities because it is just evil in the
first place to begin with.

>Additionally, I'm unsure of what is the meaning of
>
>"GPL and additional rights"     [GNU Public License v2 rights and more]

I think (but I may be wrong) that e.g. "GPL+BSD" fall into this. (Which
not change the fact that you are still obliged to comply with the GPL.)

>
>Thank you,
>Nathan
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

	Jan
-- 
