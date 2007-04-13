Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXDMAvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXDMAvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXDMAvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:51:31 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42580 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbXDMAva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:51:30 -0400
X-Sasl-enc: A1wtagui4+ewA/D4NEfLP5/IpukR8baggKJtBgQSTdYR 1176425489
Date: Thu, 12 Apr 2007 21:51:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Paul Sokolovsky <pmiscml@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070413005112.GA20890@khazad-dum.debian.net>
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org> <1734853889.20070412173626@gmail.com> <20070412185630.GC27804@khazad-dum.debian.net> <20070412204413.GA3151@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412204413.GA3151@zarina>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Anton Vorontsov wrote:
> Let's name attributes with mWh units as {min_,max_,design_,}energy,
> and attributes with mAh units as {min_,max_,design_,}charge.

[...]

> * Yup, I've read last discussion regarding batteries, and I've seen
>   objections against "charge" term, quoting Shem Multinymous:
> 
>   "And, for the reasons I explained earlier, I strongly suggest not using
>   the term "charge" except when referring to the action of charging.
>   Hence:
>   s/charge_rate/rate/;  s/charge/capacity/"
> 
>   But lets think about it once again? We'll make things much cleaner
>   if we'll drop "capacity" at all.

I stand with Shem on this one.  The people behind the SBS specification
seems to agree... that specification is aimed at *engineers* and still
avoids the obvious trap of using "charge" due to its high potential for
confusion.

I don't even want to know how much of a mess the people writing applets
woudl make of it...

> > That said, you may need to use uWh and uAh instead of mAh and mWh, though.
> 
> Not sure. Is there any existing chip that can report uAh/uWh? That is
> great precision.

The way things are going, it should be feasible for small embedded systems
quite soon.  Refer to the previous thread.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
