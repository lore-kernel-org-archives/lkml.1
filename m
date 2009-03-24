Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbZCXLcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbZCXLcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZCXLci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:32:38 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:53373 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZCXLcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NM9m2ONFG1Gs2DX2EK+6rg57HNCYC5qUTQfzu3ey/9EBghttvQ1BeiBDrlWZ9MJsVZ
         ibrykMdAZWIQyCfaBreisSYE24q2aFn9wTzpCy5ly/GSpcgGhTDRotTpF3CN8k1wamkA
         QaUpumNrZn+WNr0ScufTVVc/dHEiNYjF99fP0=
MIME-Version: 1.0
In-Reply-To: <20090322.215110.261185328.davem@davemloft.net>
References: <a4423d670903180958j4847717eh99a41534633dd314@mail.gmail.com>
	 <20090318.234451.38898787.davem@davemloft.net>
	 <a4423d670903190116p157b2ebfl69d270e0576c6d9a@mail.gmail.com>
	 <20090322.215110.261185328.davem@davemloft.net>
Date: Tue, 24 Mar 2009 14:32:32 +0300
Message-ID: <a4423d670903240432m1a4e8e08x9c97a0947d89800a@mail.gmail.com>
Subject: Re: next-20090318: sunhme does not transmit packets
From: Alexander Beregalov <a.beregalov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-next@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 2009/3/19 David Miller <davem@davemloft.net>:
>> > Does the current vanilla kernel work fine?
>>
>> Yes. The problem happens only with -next tree.
>
> I have one of my ultra10s up and will try to reproduce and diagnose
> this locally.

Hi David

2.6.29 also does not work.

The guilty patch should be between 2.6.29-rc8 and final 2.6.29

even more narrow - 59fcbdd..v2.6.29

I can try to bisect.
