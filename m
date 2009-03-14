Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZCNCU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZCNCU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZCNCUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 22:20:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47447
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbZCNCUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 22:20:06 -0400
Date: Fri, 13 Mar 2009 19:19:51 -0700 (PDT)
Message-Id: <20090313.191951.228619450.davem@davemloft.net>
To: therbert@google.com
Cc: yanmin_zhang@linux.intel.com, bhutchings@solarflare.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to
 submit to upper layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <65634d660903131724s49009177pdc11005aa76a4b56@mail.gmail.com>
References: <65634d660903131459m645eb468y3ad850a1fd56d447@mail.gmail.com>
	<20090313.151913.21135937.davem@davemloft.net>
	<65634d660903131724s49009177pdc11005aa76a4b56@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Herbert <therbert@google.com>
Date: Fri, 13 Mar 2009 17:24:10 -0700

> Enabling HW multi-queue has somewhat higher CPU
> utilization though, the extra device interrupt load is not coming for
> free.  We actually use the HW multi-queue in conjunction with our
> software steering to get maximum pps (about 20% more).

This is a non-intuitive observation.  Using HW multiqueue should be
cheaper than doing it in software, right?
