Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbZCMVCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbZCMVCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZCMVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:02:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37387
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbZCMVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:02:31 -0400
Date: Fri, 13 Mar 2009 14:02:17 -0700 (PDT)
Message-Id: <20090313.140217.143696945.davem@davemloft.net>
To: therbert@google.com
Cc: yanmin_zhang@linux.intel.com, bhutchings@solarflare.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to
 submit to upper layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <65634d660903131358h765bef64y6a0f1b0db7400f6f@mail.gmail.com>
References: <65634d660903131006n44f068dw18b2fe9dce25399e@mail.gmail.com>
	<20090313.115137.254924980.davem@davemloft.net>
	<65634d660903131358h765bef64y6a0f1b0db7400f6f@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Herbert <therbert@google.com>
Date: Fri, 13 Mar 2009 13:58:53 -0700

> We are trying to follow the decisions scheduler as opposed to
> leading it.  This works on very loaded systems, with applications
> binding to cpusets, with threads that are receiving on multiple
> sockets.  I suppose it might be compelling if a NIC could steer
> packets per flow, instead of by a hash...

If the hash is good is will distribute the load properly.

If the NIC is sophisticated enough (Sun's Neptune chipset is)
you can even group interrupt distribution by traffic type
and even bind specific ports to interrupt groups.

I really detest all of these software hacks that add overhead
to solve problems the hardware can solve for us.
