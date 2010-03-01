Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab0CALkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 06:40:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52794 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0CALkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 06:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YmtzVvU4YmcyaAZMq5Cb8mIqXPHxe8FQTte5yduVy0qHQHqwMPN/daDOQgLRynv/6a
         YH3ILGgKnGeVWBAnXGRjIgakHe8T1xjXDUnZ11CiuEU9JlF9vlHJPq8FACHhNr2bRvez
         GnPyNVXlK9231ts7tPKI6blcawaW+fm9TsUSU=
MIME-Version: 1.0
In-Reply-To: <20100301105329.GA2684@jm.kir.nu>
References: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
	 <20100301075953.GA32038@jm.kir.nu>
	 <9c30dffe1003010012l5b3a912fma5655e630b83ce9f@mail.gmail.com>
	 <20100301105329.GA2684@jm.kir.nu>
Date: Mon, 1 Mar 2010 12:40:14 +0100
X-Google-Sender-Auth: 6b910908baa126a2
Message-ID: <9c30dffe1003010340r20a179c6hd2d5e7eeeba8d106@mail.gmail.com>
Subject: Re: Problem with bridges and wireless NIC's
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Jouni Malinen <j@w1.fi>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/1 Jouni Malinen <j@w1.fi>:
> On Mon, Mar 01, 2010 at 09:12:48AM +0100, Bjarke Istrup Pedersen wrote:
>> That sounds interresting, is there any chance that that functionality
>> can be added to the 0.6.x branch too? (I'm maintaining hostapd in
>> Gentoo, but cannot stabilize a 0.7.x build, due to it being a
>> development branch)
>
> While it might be relatively simple to port the bridge setup code into
> 0.6.x, I'm not that keen on doing it for this particular reason. I'm
> recommending 0.7.x branch for all AP functionality with nl80211-based
> driver interface and as such, do not really want to promote use of 0.6.x
> versions for this.
>
> I started working on porting the driver_nl80211.c changes into the 0.6.x
> branch, but that turned up to take way too much effort compared to what
> the potential benefit would be. As such, I do not plan on continuing on
> this direction and you should be prepared to quite a bit of additional
> work on porting non-trivial fixes from hostapd 0.7.x yourself if you
> plan on using hostapd 0.6.x in Gentoo with mac80211/nl80211-based
> drivers.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Okay, so the best thing to do, is to advise people to reverse the
patch if the need 0.6.x, or use 0.7.x - right?
If so, thats fine with me :-)

Best regards,
Bjarke Istrup Pedersen
