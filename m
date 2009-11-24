Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbZKXLbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbZKXLbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbZKXLbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:31:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:16488 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbZKXLbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:31:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PgahKXYXmc0m5Y6Wk5Oo0w6Hj6N3D67wxmJSIwqtPuFwV48clKUw13bNyWTD//BCj4
         MJYXwHvfleZQzt+cgT9SDuzKpOL/212kzKIwGZQPJBf6qXa3vN9m5DGpTmpJPhvIaEXz
         pSrj5m4MNvy4Zt2aYYg+DoLpCacnPPoVc/NHQ=
MIME-Version: 1.0
In-Reply-To: <200911241032.29820.jbe@pengutronix.de>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
	 <200911241032.29820.jbe@pengutronix.de>
Date: Tue, 24 Nov 2009 09:31:06 -0200
X-Google-Sender-Auth: 6a773cb9ce1f1f0c
Message-ID: <be7a9f3d0911240331n61637196gf243af4e607403ff@mail.gmail.com>
Subject: Re: Vortex86SX: only works with irqpoll
From: Otavio Salvador <otavio@ossystems.com.br>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Juergen,

On Tue, Nov 24, 2009 at 7:32 AM, Juergen Beisert <jbe@pengutronix.de> wrote:
> On Donnerstag, 19. November 2009, Otavio Salvador wrote:
>> I got this machine working booting it with "irqpoll" parameter however
>> it drops the performance a lot and I'd like to try to fix the root
>> problem of it.
>>
>> Without 'irqpoll' the disk and network adaptor doesn't work.
>
> What kernel revision do you are using?

I tested it with 2.6.31 and 2.6.32-rc7.

> We are using a Vortex86DX here and it works as expected. But I do not know the
> differences in the SoCs of Vortex86SX and Vortex86DX (okay, SX lacks the
> floating point unit). Find our dmesg output attached. Maybe it could help.

I'll take a look on the dmesg output and see if I see something interesting :-)

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
