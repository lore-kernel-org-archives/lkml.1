Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0CAXOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:14:45 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61591 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0CAXOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:14:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fOITKzU+Fo2a+HRCqXM+/ypidL9nE3HCusSVLPyWdGwuv/+yqgLg2bbp98WYBJ8kxo
         j1gjjLB09cZ5596RHMg5X7mhGGacd5N9mbOaKTNFyq1ehmoTKKb1EPSkQcvpXxCkvi5e
         DEVCeytCqYykx1bNAcpZPELNF4uKsc9ZYBJsU=
MIME-Version: 1.0
In-Reply-To: <20100301131801.GA3449@jm.kir.nu>
References: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
	 <20100301075953.GA32038@jm.kir.nu>
	 <9c30dffe1003010012l5b3a912fma5655e630b83ce9f@mail.gmail.com>
	 <20100301105329.GA2684@jm.kir.nu>
	 <9c30dffe1003010340r20a179c6hd2d5e7eeeba8d106@mail.gmail.com>
	 <20100301131801.GA3449@jm.kir.nu>
Date: Tue, 2 Mar 2010 00:14:42 +0100
X-Google-Sender-Auth: b19358adec11e6d8
Message-ID: <9c30dffe1003011514j21fdb9d7t9ce277fb133dcf27@mail.gmail.com>
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
> On Mon, Mar 01, 2010 at 12:40:14PM +0100, Bjarke Istrup Pedersen wrote:
>> Okay, so the best thing to do, is to advise people to reverse the
>> patch if the need 0.6.x, or use 0.7.x - right?
>
> I don't think I would recommend people to reverse the commit that made
> kernel reject invalid wlan0 mode in the bridge in general. It should be
> possible to reorder network configuration to work with it and if really
> not, reverting that change is reasonable only for a device that works as
> an AP and uses bridging. Alternatively, whoever needs hostapd 0.6.x for
> whatever reason could obviously also backport the hostapd patch for
> bridge setup.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Okay, I have recommended people to upgrade to 0.7.1 and configure
hostapd to do the adding to the bridge :-)
Thanks for helping.

Btw. - is there a timeframe for when 0.7.x might go stable? (the WPS
stuff is really interresting) :-)
