Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab0BEI4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:56:08 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34531 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0BEI4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:56:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fi2WOx+RudlHHR8IUGY0C/DX1Y+HcgveIG6mzKBh54g3KI70Z31O63ssKxBkHyoCiI
         L6c2K0Q7c8+hw9ndBAL2TJ2W4WfpHAQUickNaZER0vLp+Zk6uDxM2ajuiH044Ody0t4W
         xlhFLr+5aymKYezdIRO88y26lc9jn+uEQSPL4=
MIME-Version: 1.0
In-Reply-To: <1265326257-4446-11-git-send-email-maximlevitsky@gmail.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
	 <1265326257-4446-11-git-send-email-maximlevitsky@gmail.com>
Date: Fri, 5 Feb 2010 09:56:02 +0100
Message-ID: <acd2a5931002050056l119844f5s30c30ccfc1a15596@mail.gmail.com>
Subject: Re: [PATCH 10/17] MTD: nand: make reads using MTD_OOB_RAW affect only 
	ECC validation
From: Vitaly Wool <vitalywool@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
       Artem Bityutskiy <dedekind1@gmail.com>, joern <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 12:30 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
> to the data buffer, however you would still need to specify the dummy oob buffer.
>
> This is only used in one place, but makes it hard to read data+oob without ECC
> test, thus I removed that behavier, and fixed the user.
>
> Now MTD_OOB_RAW behaves like MTD_OOB_PLACE, but doesn't do ECC validation
>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c |    5 -----
>  drivers/mtd/nand/nand_bbt.c  |   26 ++++++++++++++++++++++----
>  include/linux/mtd/mtd.h      |    4 +---
>  3 files changed, 23 insertions(+), 12 deletions(-)

Could you please provide a clearer description of why you think this
is necessary?

Thanks,
   Vitaly
