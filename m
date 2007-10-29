Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbXJ2Uwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbXJ2Uwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXJ2Uwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:52:39 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:13429 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752066AbXJ2Uwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R6DCwPOOfbjREAHfbBsSn+wmt60EYRXckKxPFEFfRfU45EaYthT/EGKeJSMS6F47CHoXdlkCM+UWA5Htm35XcYd7hP8gDQ1sotsfF20FBWqMKAW6qLDMuDlcF27QTK6sEimEdibjVaIhKfZIJ3AQuxhgyV/R9E8NTocAzWzo64Y=
Message-ID: <b3790d380710291352k83e04ebl331f8bb784ba218c@mail.gmail.com>
Date: Mon, 29 Oct 2007 21:52:35 +0100
From: "Wijnand Rietman" <wijnand.rietman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_IDEDMA_AUTO & 2.4.32 & hdparm -d1
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <20071029194241.GA27646@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b3790d380710290605g5d1770fao675418f062f111b9@mail.gmail.com>
	 <20071029194241.GA27646@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The way I booted was to
> pass 'ide=nodma' and that worked fine (at least on the sc1200).
>
> I could enable dma with hdparm later if I wanted (which of course made
> the ide driver rather upset when it tried to then use the non existant
> dma lines).
>
> --
> Len Sorensen
>

Thanks Lens for the suggestion!

Unfortunately this option doesn't work either. When I pass the "nodma"
paramater to the kernel, it boots with DMA disabled (like it should),
but doesn't allow DMA to be enabled anymore with hdparm.
