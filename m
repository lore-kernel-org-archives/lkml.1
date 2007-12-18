Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbXLRLxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbXLRLxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXLRLxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:53:36 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:9389 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbXLRLxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:53:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=r1wF18ahBknN9479BDwjtfr2e8qvtT/L4bryh/8/hQXergiX5VUJmJVLCjSgw5RGNzA1E922raPV+ltQSNSsmFbBzm0MDCKDQqwQTh6MTnBMR4UOVXxjbP2eXXG90miQWioN9B3472lnT1hZ3BWYbDNQTrdtchhtWaz4KJn0yAg=
Message-ID: <3efb10970712180353o3062eae5gf1bf9b51230960a1@mail.gmail.com>
Date: Tue, 18 Dec 2007 12:53:33 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Cc: "Andrew Victor" <avictor.za@gmail.com>, linux-kernel@vger.kernel.org,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <20071218112907.609cc013@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970712070724i6fa66666t2b8422329759ce24@mail.gmail.com>
	 <3efb10970712131232j5f747420g4aa8b5bd956e3dd3@mail.gmail.com>
	 <3efb10970712131235t47a9ceb5y7d9a7d5023d07bf6@mail.gmail.com>
	 <3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com>
	 <20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com>
	 <3efb10970712171256v4230eb38q84d01f2d0d554935@mail.gmail.com>
	 <20071217234932.GH23657@flint.arm.linux.org.uk>
	 <20071218100724.3e79629e@dhcp-252-066.norway.atmel.com>
	 <cd73a99e0712180208x73eb1095qbea96f1a9746298b@mail.gmail.com>
	 <20071218112907.609cc013@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 505cff60bc4729e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> I don't think so, but I don't feel all that strongly about it. I'd
> actually prefer if we used at_writel() and at_readl() throughout the
> code and killed those UART_PUT/UART_GET macros.

I completely agree.

Kind Regards,

Remy
