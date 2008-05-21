Return-Path: <linux-kernel-owner+w=401wt.eu-S936648AbYEUSBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936648AbYEUSBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765791AbYEUSBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:01:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:28139 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560AbYEUSBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sMQu0DAmVOOZab+KMzoYC8TuUBXAF3N3F5JGEOFzsQcNqgAmD48N7v3m/wlEF5XEKNlIMUH95WyIEvQcGFyay8L/t/s4ldnN14Q9TLb4iRAZ8++SfF5ggm0XEnETj0XP5H/bRz2Zl35j0rR1fjbPSlnDgzuce2Zugqd9V0yY+rc=
Message-ID: <7b9198260805211101s1fb96533tc86a614008833741@mail.gmail.com>
Date: Wed, 21 May 2008 19:01:10 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.24 not recognizing 2G MMC card?
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <20080521172104.GC2592@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080521172104.GC2592@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 J. Bruce Fields <bfields@fieldses.org>:
> Please forgive a somewhat naive question--I'm not sure how to go about
> debugging this kind of thing:
>
> I have a Dell 1420n with card readers reported by lspci as:
>
> 03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
> 03:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
>
> I have a 512MB MicroSD card which seems to be recognized fine, but a 2GB
> MMC card is not.
>
> I'm using a stock Ubuntu 8.04 kernel, which reports itself as
> 2.6.24-16-generic.
>
> Skimming through commits to drivers/mmc,
> 5ae70296c85f96a9969891d9de3410ebdf210b71 "mmc: Disabler for Ricoh MMC
> controller", looks relevant, but seems to be included in 2.6.24.
>
> Anything I should try?  Thanks in advance for any suggestions.
>
> --b.

Hi,

What does: lsmod | grep ricoh, give you?  Anything?

-- 
Tom Spink
