Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZC3SNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZC3SNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZC3SNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:13:39 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:56502 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZC3SNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cDCIHMAu/D5OaLkIdFTza2ChXF27KkYkgx63svzwQNpQlWk68EIf7xmSXZ5pWEh173
         Jka4fT24/9H/yGSOhPzroOMx1wXVo2hBqae5Co4Tj3D+Uk6l5lBhyTjhVOIvMYzvDVc7
         wGCSLsDatuiOHpQGi8MSmy+z9avWnYiT9Eqn8=
MIME-Version: 1.0
In-Reply-To: <20090330175951.GB4199@linux.vnet.ibm.com>
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com>
	 <1231338965-796-1-git-send-email-jirislaby@gmail.com>
	 <20090107152208.GB4207@linux.vnet.ibm.com>
	 <4964CAAA.3040801@gmail.com>
	 <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com>
	 <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com>
	 <20090330085952.GB3837@linux.vnet.ibm.com>
	 <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com>
	 <20090330175951.GB4199@linux.vnet.ibm.com>
Date: Mon, 30 Mar 2009 14:13:35 -0400
X-Google-Sender-Auth: 00a0623e435ed669
Message-ID: <b6c5339f0903301113y6cb0b8bu1eaa55439eb18d97@mail.gmail.com>
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
From: Bob Copeland <me@bobcopeland.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dhaval Giani <dhaval.lists@thegianis.in>,
       linville@tuxdriver.com, davem@davemloft.net,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 1:59 PM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> ok, so my kernel does hve this patch applied, and this is what I get,
>
>  ------------[ cut here ]------------
>  WARNING: at include/net/mac80211.h:1956 minstrel_get_rate+0xa1/0x4b9 [mac80211]()

I believe this is something different (tx path not rx).  I think it's
that minstrel rate table bug again, which we never solved for ath5k.

Are you using adhoc or managed mode?  Do you have the slab/slub debugging
options turned on?  Any steps that consistently reproduce it?  Do you
get any warnings with PID controller?

-- 
Bob Copeland %% www.bobcopeland.com
