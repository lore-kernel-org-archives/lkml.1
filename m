Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818Ab0A2REW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0A2REW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308Ab0A2REV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:04:21 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:52419 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0A2REV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xIC9NhkqmGq8Q7D0pmDimDMPzfvf8rwl0J6fT8OwosIVyeRvfUO6lUuEke1W5wX1y/
         Et5faodpHS8AbZlrY7PPbUPAQSNWkB5NHy37HIGMLDj9AE31qZiOKUYHiXF7x8r6eKAb
         3SkHFdKqpAKx7i9VViw2fE5v1udsWm3UwBb/k=
MIME-Version: 1.0
In-Reply-To: <20100129162155.709756286@gmail.com>
References: <20100129162029.998540038@gmail.com>
	 <20100129162155.709756286@gmail.com>
Date: Fri, 29 Jan 2010 18:04:19 +0100
X-Google-Sender-Auth: e9c7cf3e79afe996
Message-ID: <3efb10971001290904p74b1919aif8ff013f050123a9@mail.gmail.com>
Subject: Re: [patch v2 1/2] at91_udc.c read_fifo timing issue
From: Remy Bohmer <linux@bohmer.net>
To: Harro Haan <hrhaan@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Andrew Victor <avictor.za@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harro,

2010/1/29 Harro Haan <hrhaan@gmail.com>:
> This solves the read_fifo timing issue for example seen with CDC Ethernet.
> See the comments below for more info.
>
> Signed-off-by: Harro Haan <hrhaan@gmail.com>
> ---
>  drivers/usb/gadget/at91_udc.c |   46 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 4 deletions(-)
>
Acked-by: Remy Bohmer <linux@bohmer.net>
