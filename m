Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYH1TnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYH1TnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYH1Tm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:42:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40842
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753498AbYH1Tm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:42:56 -0400
Date: Thu, 28 Aug 2008 12:42:51 -0700 (PDT)
Message-Id: <20080828.124251.149964287.davem@davemloft.net>
To: rick.jones2@hp.com
Cc: jmalicki@metacarta.com, andi@firstfloor.org, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, denys@visp.net.lb, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
From: David Miller <davem@davemloft.net>
In-Reply-To: <48B6E7D0.5070307@hp.com>
References: <21915755.1327801219904892242.JavaMail.root@ouachita>
	<48B6E7D0.5070307@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rick Jones <rick.jones2@hp.com>
Date: Thu, 28 Aug 2008 11:00:48 -0700

> Earlier in the thread mention was made of financial services types.
> If someone has knowledge of the (probably) arcane rules under which
> they must operate it would be great to hear more.  Does some entity
> like the SEC (Securities and Exchange Commission in the United
> States) mandate some sort of timestamp for when the trading request
> "arrives at the trading system" and do they define that "arriving at
> the trading system" means?

The issue is the ordering of processing the requests.

So if request A arrived on interface 1 before request B arrived on
interface 2, the trade described in A should be performed before the
one in B.

This is not "arcance" as you seem to suppose it might be, but rather
pretty clear fair handling or requests sent between trading desks.

