Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0CADNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 22:13:52 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:49950 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0CADNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 22:13:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TiXwoG4Zn4QtDVbW5pL40lKd32UJqiHczrP7wbWtjO00xCew6kprErAmDGaWYp3N20
         Rl/9bGKVwi7HdeD8VQy+qXzlCjG5rUaTbXf0Q4Uqh7XvyNBJltP4A53hwoh9ONUBOfUD
         wP0Jv0pM84GRlIWD+xjQg2uHu1WBBaZt99rm0=
MIME-Version: 1.0
In-Reply-To: <1267382520.12641.29.camel@Joe-Laptop.home>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
	 <1267382520.12641.29.camel@Joe-Laptop.home>
Date: Mon, 1 Mar 2010 12:13:49 +0900
Message-ID: <961aa3351002281913w5c009443v4a90793ffc37d2c2@mail.gmail.com>
Subject: Re: [PATCH] alpha: use __ratelimit
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/1 Joe Perches <joe@perches.com>:
> On Sun, 2010-02-28 at 19:58 +0900, Akinobu Mita wrote:
>> Replace open-coded rate limiting logic with __ratelimit().
>
> Perhaps printk_ratelimited?

This patch is cleanup only and no functionnal change (it does not change
the rate limit interval and burst).

But using printk_ratelimited() changes the burst count from 5 to 10.
It may not be big difference but I'm not sure...
