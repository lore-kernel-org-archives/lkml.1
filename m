Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbYA1KW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbYA1KW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYA1KWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:22:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:55282 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYA1KWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qmhN7JsEGurkj/jdgYG1hVAU2mW346pyW5zLHtPDdHNtK6ictSNQLQQcv/Ccl+nSoaJUAwbzOQ47IHElMVAAywTbZlnAFMfJ6BsG1zcBcgoKzC4l+rNx2BOuEnmy3fbMfyh74gPLQ0UYB4zisjLbO9cp7SF1/ipqHhRvQinimhU=
Message-ID: <38b2ab8a0801280222m3aadc1b1t792165174733b04d@mail.gmail.com>
Date: Mon, 28 Jan 2008 11:22:49 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: Question about DMA
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080128102149.545c0619@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
	 <479D06E0.3090601@gmail.com>
	 <38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
	 <20080128102149.545c0619@dhcp-252-066.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

On Jan 28, 2008 10:21 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Mon, 28 Jan 2008 09:55:58 +0100
> "Francis Moreau" <francis.moro@gmail.com> wrote:
>
> > My DMA controller has very little in common with ISA DMA one. But I'd like to
> > use it in a driver. This driver can do DMA but with the help of an external DMA
> > controller. It's only implement the "slave" side. So basically this driver needs
> > to configure one of the DMAC channels before transfering data.
>
> Have a look at this thread:
>
> http://lkml.org/lkml/2007/11/23/79
>
> I'm planning to post an updated patch set this week that addresses the
> comments by Dan Williams, and that applies on top of the other DMA
> Engine patches that have been posted since then.
>
> Please let me know if you think this will work for your hardware.

Thanks for pointing this out. I currently can't look at this but I'll
try to give it
a deep look this week.

> What platform are you working on, btw?
>

SH

Thanks.
-- 
Francis
