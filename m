Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYFBJsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYFBJsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYFBJsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:48:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58548 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986AbYFBJsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:48:17 -0400
Message-ID: <4843C1DB.4080500@sgi.com>
Date: Mon, 02 Jun 2008 11:48:11 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: benh@kernel.crashing.org, Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, Jeremy Higdon <jeremy@sgi.com>
Subject: Re: MMIO and gcc re-ordering issue
References: <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop> <adaiqwzsa83.fsf@cisco.com> <yq0iqwxrwuh.fsf@jaguar.mkp.net> <1212097223.8888.55.camel@pasglop> <483FCD5C.208@sgi.com> <20080531081450.GI5405@ucw.cz>
In-Reply-To: <20080531081450.GI5405@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Still better than changing semantics of writel for _all_ drivers.
> 
> If you are really sure driver does not depend on writel order, it is
> just a sed/// command, so I don't see any big code maintenance
> issues...

This isn't changing the semantics for all drivers, it means it leaves
it up to us to fix the drivers that hit the problem. Whereas the other
way round we'd have to make some fairly big modifications to a large
number of drivers, which the driver maintainers are likely to be
reluctant to accept and maintain. It will be a constant chase to keep
that in order.

Cheers
Jes


