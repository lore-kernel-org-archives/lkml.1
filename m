Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYGULZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYGULZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYGULZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:25:44 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:48345 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYGULZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:25:43 -0400
Date: Mon, 21 Jul 2008 15:25:15 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cl@linux-foundation.org,
       davem@davemloft.net
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Message-ID: <20080721112515.GA4777@2ka.mipt.ru>
References: <20080717214222.GA29449@elte.hu> <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI> <20080718091146.GQ6875@elte.hu> <20080721094110.GA16029@elte.hu> <84144f020807210252k68d5cf65i8c7ae3c11cecc046@mail.gmail.com> <20080721100627.GA5953@2ka.mipt.ru> <20080721105051.GA5830@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721105051.GA5830@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 12:50:51PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> > Ingo do you see other similar dumps with last byte modified? That's 
> > the one which can help to determine the reason.
> 
> the problem is, most of the crashes dont come with any usable dump. This 
> is a laptop so netconsole is the only reliable route out - and if 
> something in networking crashes chances are that it hoses netconsole 
> before it can get anything out.
> 
> Another thing is that i'm activating netconsole on this box via a kernel 
> boot line and from within a bzImage (to get it activated as early as 
> possible) - maybe that's a tad too early for certain initialization 
> sequences?
> 
> I could try run tests with netconsole deactivated, if you think that's a 
> worthwile line of probing this problem. (although that would make me do 
> blind tests in essence - having kernel log output is really essential.)

Let's try this way first. If system will continue to crash, we will add
some debug options in various pathes. Existing reports do not contain
enough information unfortunately, so we will not lose too much.

-- 
	Evgeniy Polyakov
