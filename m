Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZF0Jth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZF0Jth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZF0Jt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:49:29 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35987 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZF0Jt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rztqWqipP7Jn4kq++68i+68i7jd47xnz8bzOxvpC5Zfyyg+O/VPQT1zPMhv/DB0z8L
         6SF3n5asETCohgWkixmq56XRVXH8p5eGWrapcPOUZP8YcU7WsA39Nftmf71/VNcZrQAr
         1/gaUBL1ssxQwpXT1VzjTfewaII4HGgZn3KtA=
MIME-Version: 1.0
In-Reply-To: <1246048132.21314.75.camel@johannes.local>
References: <200906261336.29318.elendil@planet.nl>
	 <8db1092f0906260459n308311faweb6d9733cdd1eb13@mail.gmail.com>
	 <200906261410.58808.elendil@planet.nl>
	 <1246048132.21314.75.camel@johannes.local>
Date: Sat, 27 Jun 2009 11:49:28 +0200
Message-ID: <8db1092f0906270249k58b3bd48yc4c93113641cc5ac@mail.gmail.com>
Subject: Re: [2.6.31-rc1] iwlagn (4965): no wireless due to RFKILL problem
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Frans Pop <elendil@planet.nl>, linux-wireless@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/26 Johannes Berg <johannes@sipsolutions.net>:

> Hmm, looks like there might be another polarity error, try this:
> -       int query = BIT(b + 8) | ((!!blocked) << b);
> +       int query = BIT(b + 8) | ((!blocked) << b);
>

This helps. hp-wmi works without any problems.

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
