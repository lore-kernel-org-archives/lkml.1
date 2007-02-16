Return-Path: <linux-kernel-owner+w=401wt.eu-S966224AbXBPIit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966224AbXBPIit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966231AbXBPIit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:38:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:50954 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966224AbXBPIis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:38:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gCEsypfW66/JdR8gagIZ3iKMK5LLtU+MfwNGA3lXlnWA4wgLXgCN8T1Bvj8Wu/SFGhb9cV95ou0n4BxN1kUX5ODb7ymiJowbeZThO4eNcyxVBQwHeqXLyolt6aJbRszQFg4lisCyjko3uHXn163mjkf5WQf7sRiTAcwjR+Dpouk=
Message-ID: <639c60080702160038o516fd790n50923afcc136ea07@mail.gmail.com>
Date: Fri, 16 Feb 2007 09:38:46 +0100
From: Nilshar <nilshar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problem with 2.6.20 and highmem64
In-Reply-To: <639c60080702140711j1ec1b344p77133bb26f687e87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <639c60080702140711j1ec1b344p77133bb26f687e87@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that it works fine with 2.6.20-rc2.
Do you need me to try any other ? do you need any more info ?

2007/2/14, Nilshar <nilshar@gmail.com>:
> Hello,
> I have an issue with latest 2.6.20 kernel..
> my last kernel was a 2.6.18 and I wanted to upgrade to a 2.6.20, I
> copied .config and did a make menuconfig, then save/quit. I compiled
> new kernel, all went fine.
> I installed it and at boot time, I had a hang just after "Freeing
> unused kernel memory" where INIT is supposed to start.
> After searching the web, I found that it is usually the case when
> wrong process type is configured.. I verified that, but all was fine
> there.
> After 10ish compiled kernel, I found that it is when I select highmem64.
>
> Diff between working and non working kernel :
>
> 181,182c181,182
> < # CONFIG_HIGHMEM4G is not set
> < CONFIG_HIGHMEM64G=y
> ---
> > CONFIG_HIGHMEM4G=y
> > # CONFIG_HIGHMEM64G is not set
> 185d184
> < CONFIG_X86_PAE=y
> 191c190
> < CONFIG_RESOURCES_64BIT=y
> ---
> > # CONFIG_RESOURCES_64BIT is not set
>
> (I just witching highmem 4G and highmem64g).
>
> I'll attach the full .config.
>
> it used to work fine with highmem64g with a kernel 2.6.18 and 2.6.19
> (I'm sure it was ok with .20-rc2 but I'll double check that).
>
> Is this a bug ? or something I did wrong ?
>
> Oh, I probably should add that this hang doesn't occur on all
> hardware, but it happen on Dell PE 850 at least.
>
> If you need additional informations, just ask :)
>
>
