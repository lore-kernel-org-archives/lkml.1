Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0BHRlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:41:11 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:61945 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0BHRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:41:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IryCCEc/MvmNfepHvQKTWru/uLzwkNBIkEDnFWKIdYcHJb+MHaR5UMMHfznjb7JJ8B
         V3aJwpbMZlfiYaEQFYbjfDmlaOr3JPUx8BXjlWUjPXH2/QoIXuJT0JTlH1KTmekp3zLR
         VlwS0PGfZGptZ9Qf+6WNH08hrHdsYW+aeeKtI=
Subject: Re: NAND: fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
References: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 19:41:02 +0200
Message-ID: <1265650862.4115.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-06 at 01:18 +0200, Maxim Levitsky wrote: 
> This is part of my patcheset that touches the nand subsystem
> 
> Stanley, patch #2 should now cover attempts to write outside the oob.
> 
> Also I did another (don't know if less or more evil) approach to bad block testing.
> Now check_bad always takes the controller locks and selects the chip. Thus it is
> possible to use read_oob/write_oob.
> This however changes behavier of the nand_erase_nand to deny erases if any block within
> the range is bad. Also it selects/releases the chip once per erase block.
> This is done in patch #5. Patch #6 is ported to that change.
> 
> Patches 1-3 are pure fixes.
> 
> Best regards,
> 	Maxim Levitsky

Any update?

Best regards,
Maxim Levitsky

