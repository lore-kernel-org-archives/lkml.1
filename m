Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbYHLOGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbYHLOGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHLOGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:06:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:53392 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbYHLOGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Fm2Cz7t+jU+QoCqEfqWpjJ6+RqIIdaSxlIX78+RPWuLKftCKUCTYWcTuOItk8QnwZh
         1kv5OFrjrzMygHHmUCjgvRHZnDc/pLX1uiHIDWpUKz3ke/3QQ6lDfV4hFUVDhWomtTs+
         NL0yGhDuYDB2x2u8SgfALOsILwA+5I1WivomY=
Message-ID: <1ba2fa240808120706s6ddd6d40vdbd9bcff8c1db5c@mail.gmail.com>
Date: Tue, 12 Aug 2008 17:06:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vladimir Koutny" <vlado@work.ksp.sk>
Subject: Re: mac80211 : WARN at net/mac80211/rate.h:153
Cc: "Dave Young" <hidave.darkstar@gmail.com>,
       "Mattias Nissler" <mattias.nissler@gmx.de>,
       "Michael Buesch" <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Stefano Brivio" <stefano.brivio@polimi.it>
In-Reply-To: <487C4050.1010006@work.ksp.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714075010.GA3559@darkstar> <200807141614.51628.mb@bu3sch.de>
	 <1216055849.4435.7.camel@localhost>
	 <a8e1da0807142251p14324917w62d751bed5a56b92@mail.gmail.com>
	 <487C4050.1010006@work.ksp.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 9:14 AM, Vladimir Koutny <vlado@work.ksp.sk> wrote:
> Dave Young wrote:
>> On Tue, Jul 15, 2008 at 1:17 AM, Mattias Nissler <mattias.nissler@gmx.de> wrote:
>>> On Mon, 2008-07-14 at 16:14 +0200, Michael Buesch wrote:
>>>> CCing PID guys.
>>>> I've seen several people hitting this. What's the meaning of this warning?
>>> It basically means the rate control cannot find any rate in
>>> local->hw.wiphy->bands[local->hw.conf.channel->band] that is supported
>>> by the sta in question. Normally this should not happen. I guess the
>>> reason is that the supported rates bits in the sta info are all zero,
>>> which would probably be a bug. I haven't seen this here, but I don't use
>>> the IBSS code either. To further investigate this, you could the
>>> following just before the WARN_ON:
>
>
> This has been solved already:
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=def5e9a210235d690e79ae660972792860568421
>
> Vlado

This pacth is wrong it causes that all IBSS traffic is transmitted
rate of BEACON (1MBit) , which is pretty bad performance like. We are
working on possible fixes.
Tomas

>>
>
>
>
