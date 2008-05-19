Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYESJxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYESJxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYESJxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:53:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:61919 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbYESJxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=sQlefEYAH3VWmhNKaj+6XsysvUW3Z8vegnRBoVpg53XYPLifNzsVjqXCEgvzhGHN7wuBhwV1ygndzpY0kVeyiWLEn76WiY/YaHxir5FE0noD3c2EOnVs7kESvJcHfwoWwnFDla83SlVw2bqfM04r1RjVnS9GQouvze2HP5Spsqk=
Message-ID: <386072610805190253g42d47d81w794b3c14c15aa890@mail.gmail.com>
Date: Mon, 19 May 2008 17:53:11 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to be copied to
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       mike@steroidmicros.com
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0183AE38@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211021526-24076-1-git-send-email-cooloney@kernel.org>
	 <8A42379416420646B9BFAC9682273B6D0183AE38@limkexm3.ad.analog.com>
X-Google-Sender-Auth: 6abcc543fbfcbf37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 5:12 PM, Hennerich, Michael
<Michael.Hennerich@analog.com> wrote:
>>+      spi_write(flash->spi, flash->command, 2);
>>+
>>+      return spi_write(flash->spi, flash->command, 2);
>
>
> I just noticed that write_sr contains a duplicated spi_write.
> Bryan sends out a new patch.
>


No problem, it is my fault. I should review the patch carefully.

Thanks
-Bryan
