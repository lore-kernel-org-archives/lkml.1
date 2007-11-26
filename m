Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXKZJOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXKZJOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXKZJOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:14:12 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:23425 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbXKZJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P33wU2CpfsrEmFe1jXDOW1dW9t/kzg56CY6+feaiNVzbeOoGBtRCGO7YQDil3RXZwOYEZxW0g8xKdHAREf+d2emzstA9FTfLL5VDZ/Rjb49N5WVx9GNE/cBFBs4iY7hXlexBqFB0CfAb7WwdpjTIcr0ONreG3Mo1Bm87yQPxxtk=
Message-ID: <5eeb9ad90711260114x793d506ay4ee5d1bb0cd8eb88@mail.gmail.com>
Date: Mon, 26 Nov 2007 10:14:08 +0100
From: DM <dm.n9107@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>
Subject: Re: [RFC] Documentation about unaligned memory access
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 23, 2007 1:15 AM, Daniel Drake <dsd@gentoo.org> wrote:
[...]
>
> Before I do so, any comments on the following?
>
[...]
>         void myfunc(u8 *data, u32 value)
>         {
>                 [...]
>                 value = cpu_to_le32(value);
>                 memcpy(data, value, sizeof(value));
>                 [...]
>         }

I suppose you mean:
memcpy(data, &value, sizeof(value));

/DM
