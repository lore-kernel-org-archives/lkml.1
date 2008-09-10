Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYIJWZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYIJWZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYIJWZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:25:10 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49554 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYIJWZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:25:09 -0400
Subject: Re: [PATCH 1/2 v6] cfg80211: Add new wireless regulatory
	infrastructure
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <43e72e890809101518k35047191hac8b796383a5638@mail.gmail.com>
References: <1221027589-19203-1-git-send-email-lrodriguez@atheros.com>
	 <1221027589-19203-2-git-send-email-lrodriguez@atheros.com>
	 <1221070650.13336.20.camel@californication>
	 <43e72e890809101318o771100f0jcac9bbea6b863ccb@mail.gmail.com>
	 <1221084429.13336.23.camel@californication>
	 <43e72e890809101518k35047191hac8b796383a5638@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 00:25:37 +0200
Message-Id: <1221085537.13336.34.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> >> > While reading through it, I came to think about regulatory_hint(). So is
> >> > there a use case where would give it the alpha2 code and the domain
> >> > itself at the same time? If not, then it would make more sense to split
> >> > this into two functions.
> >>
> >> Nope, you either pass an alpha2 or an rd domain which is built by you
> >> (and in that rd structure you can set the alpha2 to your iso3166
> >> alpha2 or "99" if unknown).
> >>
> >> > Maybe something regulatory_alpha2_hint() and
> >> > regulatory_domain_hint(). Just a thought.
> >>
> >> That's how I had it originally but decided to condense it to one
> >> routine since as you could see they pretty much do the same thing
> >> except the case where the rd is provided it calls set_regdom().
> >> Setting it back to use two routines if fine by me too. What is better?
> >> Can we just get this merged and then we can flip it around if
> >> necessary? :) I'm tired of carrying this around.
> >
> > my take on this is that if from an API perspective you can only use one
> > parameter or the other, then it should be two functions.
> 
> This is reasonable, I'll respin, yet once again...

get an agreement with Johannes on the naming. Either _alpha2_hint() or
_hint_alpha2(). Not sure what the others are preferring.

Regards

Marcel


