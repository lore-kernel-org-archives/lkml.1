Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287Ab0ASMmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0ASMmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575Ab0ASMmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:42:31 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53915 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab0ASMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:42:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ihf19fan9qTsr0GEImMYQ+J/wU8tbM+RYUTTqnoZAtDTmRZRLl9XLsUt09P+2Ducyr
         Sd2q3bm0Ec9uiJ5YRYNuIiCmalnqKWD6f/ErZ+iD/tBcgcFnh7J0Jl6crjmDYsgeqbSK
         Z+2TKEMy5uwValhI1NVXx+ko3Gj/kueGT4jWA=
MIME-Version: 1.0
In-Reply-To: <20100119111207.GC554@sortiz.org>
References: <1262997509-5680-1-git-send-email-linus.walleij@stericsson.com>
	 <1263250075.29868.4750.camel@calx>
	 <63386a3d1001171118n6ac88fccx12b7fdfeda204f50@mail.gmail.com>
	 <20100119111207.GC554@sortiz.org>
Date: Tue, 19 Jan 2010 13:42:29 +0100
Message-ID: <63386a3d1001190442s630e292ehf6bc63cec18272e5@mail.gmail.com>
Subject: Re: [PATCH] Use AB3100 MFD core IRQ for interrupt randomness
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       Robin Getz <rgetz@blackfin.uclinux.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/19 Samuel Ortiz <sameo@linux.intel.com>:

> I had to change the ab3100 Kconfig entry as those random.c symbols are not
> exported. The ab3100 driver is now a bool, depending on I2C=y.

Fine with me. We mainly need it to be a module when developing initial
support anyway. If you activate stuff like regulators it will be required to
compile in.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Linus Walleij
