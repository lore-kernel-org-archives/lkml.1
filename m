Return-Path: <linux-kernel-owner+w=401wt.eu-S1422644AbXBAIKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422644AbXBAIKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422647AbXBAIKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:10:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:33199 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422644AbXBAIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:10:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aFLtd5dRLnjqEsfjBzoO+USSbazdB0043Gjeisdqohx86ud2Z3CW9Fz5FBy10vn++vKAHbZdplZ67x+ADI2v/IrJYzpk7M4fbNg0Sq3qjlivKROBZ47yHSE6EDFcbw3Z9Py6b/XYgOj1gk3VovJ9Z7SKylIlKM0wNLIizlMfaLQ=
Message-ID: <87d3b2040702010010h7534cc9cte1605e5cecd56025@mail.gmail.com>
Date: Thu, 1 Feb 2007 09:10:10 +0100
From: "Frederic Riss" <frederic.riss@gmail.com>
To: "bibo,mao" <bibo_mao@linux.intel.com>
Subject: Re: [PATCH] EFI x86: pass firmware call parameters on the stack
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       artiom.myaskouvskey@intel.com, akpm@osdl.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <45C1513F.1000706@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170183678.21603.73.camel@funkylaptop>
	 <200701301217.47520.bjorn.helgaas@hp.com>
	 <1170189677.21603.102.camel@funkylaptop>
	 <45C1513F.1000706@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/1, bibo,mao <bibo_mao@linux.intel.com>:
> currently x86_64 kernel does not support efi, efi convention comply to
> MS convention. On ia32 parameter is passed on stack, on x86_64 parameter
> is passed by registers but that is different from x86_64 linux convention.

Is an x86_64 EFI firmware required to have 2 entry points, one x86_64
and one in ia32 mode ? If that's not the case, it means that an i386
kernel won't be able to work correctly on an EFI powered x86_64 box...

> How about adding EFIAPI prefix before efi runtime service function, this
> prefix has different definition in different architecture.

Have you any objection to the second patch I posted? It's not only a
matter of passing arguments, ia64 does quite a lot of things in its
wrapper functions. I can easily imagine that such additional work
could be added in the i386 wrappers if EFI becomes more widely used.
