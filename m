Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZCMWTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZCMWTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbZCMWT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:19:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59966
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbZCMWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:19:27 -0400
Date: Fri, 13 Mar 2009 15:19:13 -0700 (PDT)
Message-Id: <20090313.151913.21135937.davem@davemloft.net>
To: therbert@google.com
Cc: yanmin_zhang@linux.intel.com, bhutchings@solarflare.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to
 submit to upper layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <65634d660903131459m645eb468y3ad850a1fd56d447@mail.gmail.com>
References: <65634d660903131358h765bef64y6a0f1b0db7400f6f@mail.gmail.com>
	<20090313.140217.143696945.davem@davemloft.net>
	<65634d660903131459m645eb468y3ad850a1fd56d447@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Herbert <therbert@google.com>
Date: Fri, 13 Mar 2009 14:59:55 -0700

> I appreciate this philosophy, but unfortunately I don't have the
> luxury of working with a NIC that solves these problems.  The reality
> may be that we're trying to squeeze performance out of crappy hardware
> to scale on multi-core.  Left alone we couldn't get the stack to
> scale, but with these "destable hacks" we've gotten 3X or so
                         ^^^^^^^^

Spelling.

> improvement in packets per second across both our dumb 1G and 10G
> NICs

Do these NICs at least support multiqueue?
