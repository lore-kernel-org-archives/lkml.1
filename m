Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbZJ3KsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbZJ3KsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZJ3KsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:48:25 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:58695 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987AbZJ3KsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:48:24 -0400
Message-ID: <6980f83370cc081eb82dc2e0bd65bcf4.squirrel@webmail.uio.no>
Date: Fri, 30 Oct 2009 11:48:24 +0100
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
From: apetlund@simula.no
To: "Rick Jones" <rick.jones2@hp.com>
Cc: "Andreas Petlund" <apetlund@simula.no>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>,
       "Eric Dumazet" <eric.dumazet@gmail.com>,
       "Netdev" <netdev@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       "David Miller" <davem@davemloft.net>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 1 sum rcpts/h 11 sum msgs/h 1 total rcpts 452 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 503C1483333703175EF75AF36B13AB8DE0E95B39
X-UiO-SPAM-Test: remote_host: 129.240.4.215 spam_score: -49 maxlevel 80 minaction 1 bait 0 mail/h: 489 total 1926835 max/h 707 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just how thin can a thin stream be when a thin stream is found thin? (to
the
> cadence of "How much wood could a woodchuck chuck if a woodchuck could
chuck wood?")
>
> Does a stream get so thin that a user's send could not be split into
four,
> sub-MSS TCP segments?

That was a nifty idea: Anti-Nagle the segments to be able to trigger fast
retransmissions. I think it is possible.

Besides using more resources on each send, this scheme will introduce the
need to delay parts of the segment, which is undesirable for
time-dependent applications (the intended target of the mechanisms).

I think it would be fun to implement and play around with such a mechanism
to see the effects.

Regards,
Andreas




