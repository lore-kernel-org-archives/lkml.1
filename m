Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZJ2POQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZJ2POQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZJ2POP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:14:15 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:38563 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbZJ2POP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:14:15 -0400
Message-ID: <66f580dbbf814a9c4b9710f13d8661d8.squirrel@webmail.uio.no>
Date: Thu, 29 Oct 2009 16:14:18 +0100
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
From: apetlund@simula.no
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "Andreas Petlund" <apetlund@simula.no>, "Netdev" <netdev@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       "David Miller" <davem@davemloft.net>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 17 sum msgs/h 3 total rcpts 410 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D3250C2E5AA8C28BBEC75A13D10D9360798DB2C1
X-UiO-SPAM-Test: remote_host: 129.240.4.214 spam_score: -49 maxlevel 80 minaction 1 bait 0 mail/h: 113 total 1919790 max/h 678 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologise that some of you received this mail more than once. My email
client played a HTML-trick on me.

>> +		icsk->icsk_backoff = 0;
>> +		icsk->icsk_rto = min(((tp->srtt >> 3) + tp->rttvar), TCP_RTO_MAX);
>
> The first part is nowadays done with __tcp_set_rto(tp).
>
> --
>  i.
>

I will address this in the next iteration of the patch.

-AP




