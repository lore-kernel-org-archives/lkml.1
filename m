Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbYFVOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbYFVOyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYFVOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:54:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:60376 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYFVOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SFReCOQ/I02faTx9h4hwFutwLU4+aqS/uKhDgEyd1Ee34JKaY5QBbqHNWouc/vVoks
         po3jWKxXPsY2am+S4XsLGGCZtHsrVNzss5UvJwe4RRBRbTwbmLeVYycYX3SYb3rUIEYl
         Bv8Mg7oJXsb17eRNnS903/9VQpbCAJvi40Z+U=
Message-ID: <cd73a99e0806220754v5cbbbeefm1c0a47ef25431391@mail.gmail.com>
Date: Sun, 22 Jun 2008 16:54:10 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/3] atmel_nand: Work around AT32AP7000 ECC errata
Cc: "David Woodhouse" <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1213948112-22348-2-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213948112-22348-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1213948112-22348-2-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Haavard,

> The ALE signal isn't correctly wired up to the ECC controller on the
> AP7000, so it starts calculating ECC during the address cycles.

Shouldn't affect the AT91's, so
  Acked-by: Andrew Victor <linux@maxim.org.za>

You might want to also change/remove the comment where the ECC hwctl()
function is registered.
It's currently:
   nand_chip->ecc.hwctl = at91_nand_hwctl;     /* unused */


Regards,
  Andrew Victor
