Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYC1AET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYC1AET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbYC1ADq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:03:46 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1165 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbYC1ADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:03:45 -0400
Subject: Re: [PATCH 1/7] [NET]: uninline skb_put, de-bloats a lot
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: ilpo.jarvinen@helsinki.fi, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
       mpm@selenic.com
In-Reply-To: <20080327.150456.39560267.davem@davemloft.net>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	 <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
	 <1206645050.4849.77.camel@localhost>
	 <20080327.150456.39560267.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 17:02:37 -0700
Message-Id: <1206662557.4849.112.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 15:04 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> > This will very likely negatively impact
> > high speed networking.
> Please run some tests before making claims like this.

I think this is the sort of change you might have argued
against accepting without performance testing not long ago.

> I might give you some slack in this area if you've
> been doing networking performance tuning for 10+ years
> but you haven't.

I've done some work in network performance testing.

cheers, Joe

