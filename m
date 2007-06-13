Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbXFMUZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbXFMUZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbXFMUZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:25:28 -0400
Received: from khc.piap.pl ([195.187.100.11]:42937 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXFMUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:25:27 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "Simon Arlott" <simon@fire.lp0.eu>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Anand Jahagirdar" <anandjigar@gmail.com>, linux-kernel@vger.kernel.org,
       security@kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       akpm@digeo.com, "Jens Axboe" <jens.axboe@oracle.com>,
       "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Patch related with Fork Bobmbing Attack
References: <25ae38200706120949vaeb8e0ascd182ef2f709d0fc@mail.gmail.com>
	<Pine.LNX.4.64.0706121931390.19578@fbirervta.pbzchgretzou.qr>
	<38425.simon.1181734449@5ec7c279.invalid>
	<200706131044.42338.dhazelton@enter.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 13 Jun 2007 22:25:23 +0200
In-Reply-To: <200706131044.42338.dhazelton@enter.net> (Daniel Hazelton's message of "Wed, 13 Jun 2007 10:44:41 -0400")
Message-ID: <m3d4zz7gb0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> writes:

> I think the reasoning here is to alert the administrator(s) to the
> possibility 
> that somebody has just tried a fork-bomb. A better test, IMHO, would be to 
> check how fast the processes are being spawned and whether a large
> percentage 
> share the same parent. (Those two taken together would better spot most 
> fork-bombs, including the very simple types that are just a simple one-liner)

Not sure if it's a great idea at all. If the attacker is dumb then the
administrator already has everything he/she needs (and more) to adjust
the luser attitude.
If it's a serious attack then the attacker will evade the tests anyway
(but he/she may not be able to overcome the limits and the admin
still have all required info etc).

If we print such things then perhaps the next patch in queue should
warn us about users trying to access /etc/shadow or issuing some
configuration syscalls?

>From a different point of view it would be alerting sysadmins about
a user who tried to create one more process than he/she was allowed
to. Isn't it crazy?
-- 
Krzysztof Halasa
