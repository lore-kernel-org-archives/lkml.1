Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXHCH2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXHCH2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXHCH2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:28:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:38004 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbXHCH17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=go+xlUe8S0aiwc7w0KT313Kl4XyH4yEtlAyegEPKQyD3V3LiohE+OnvrmI6ZrglaHCje+xeY+DU0kAK7HZo/MeXkWJSou9woVtwugXi47QV2Ri2Xx712bXm81YeTOnahm7HjlK/aww7jJ6j+rva4qUyv42nWxpfbG/ASpaq1ufo=
Message-ID: <a8e1da0708030027n38c18e34ld8bc18fc103179f8@mail.gmail.com>
Date: Fri, 3 Aug 2007 07:27:58 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: dwmw2@infradead.org
Subject: Re: MTD: pnc2000 iomem oops
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
In-Reply-To: <a8e1da0708010135we34a17dl604d9f8c3eb630f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0708010135we34a17dl604d9f8c3eb630f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/1/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi,
> The pnc2000 probe function  cause oops. Possible reason is its iomem
> region not being remaped.
>
> I searched lkml history, the oops was reported at 2006-06-14, but still there.
> http://lkml.org/lkml/2006/6/14/59
>
> If the ioremap/iounmap can be added to it, is it the right fix?
>
Add the linux-mtd list as cc.
