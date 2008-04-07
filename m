Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYDGAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYDGAYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 20:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYDGAYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 20:24:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:53698 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYDGAYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 20:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MO8jl6pyEWwujttCWV3c7Drao00+v0SSsF0tepXgGYlSCMloTO4a+FP+x/DBPsG+o3S5dScMkCcDpmrYXyymHxqTLSmFQ+kzEMy86SLt3frcDzJnv+lMQdK64WLu/Blc3vwudrRfknrM6t1NrldTrCkmtf6E1GnM7Bs1/AV8odA=
Message-ID: <ac67d9130804061724v74856a30ta8b128cc5b69cf80@mail.gmail.com>
Date: Mon, 7 Apr 2008 02:24:04 +0200
From: "Szilveszter Ordog" <slipszi@gmail.com>
To: "Ben Nizette" <bn@niasdigital.com>
Subject: Re: [BUG, bisected] atmel_spi: hard lockups in transfer
Cc: kernel <kernel@avr32linux.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1207438118.3319.8.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207438118.3319.8.camel@moss.renham>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  For some weeks now there have been reports flying across the main AVR32
>  support forum, avrfreaks [1], that atmel_spi now hard-hangs on most
>  transfers.  The behaviour is not apparent in .23 and is in .24+.  One
>  tester was good enough to bisect the problem and turned up
>
>  154443c72f47169ebcb3a7befbff0e934c49bff3
>  atmel_spi: chain DMA transfers
>
>  as the culprit.

Thanks for reporting this. Unfortunately it is difficult to test for
me, since I do not have the hardware and there are no error messages.
However, if you add the following line

#define DEBUG

to the top of drivers/spi/atmel_spi.c (before the #include directives)
and recompile the kernel, then you would get lots of debug output
which could help us pinpoint the problem.

Szilveszter
