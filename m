Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYH1Uci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYH1Uci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYH1Uc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:32:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39594
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755172AbYH1Uc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:32:27 -0400
Date: Thu, 28 Aug 2008 13:32:23 -0700 (PDT)
Message-Id: <20080828.133223.119110675.davem@davemloft.net>
To: rick.jones2@hp.com
Cc: jmalicki@metacarta.com, andi@firstfloor.org, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, denys@visp.net.lb, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
From: David Miller <davem@davemloft.net>
In-Reply-To: <48B70AAA.7010504@hp.com>
References: <48B6E7D0.5070307@hp.com>
	<20080828.124251.149964287.davem@davemloft.net>
	<48B70AAA.7010504@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rick Jones <rick.jones2@hp.com>
Date: Thu, 28 Aug 2008 13:29:30 -0700

> Has the request "hit the trading system" when it hits the NIC, or
> when it hits the application executing the trade?  If the SEC calls
> for when it hits the NIC, then none of what is done today is really
> accurate/correct and one would need to start using NIC HW
> timestamps, synchronized with the host and the other NICs in the
> system no?

The SEC isn't mandating anything here, stop framing it that way :-)

People simply won't trade with a firm if they find out that trades
there are executed out of order.

They are simply trying to make things as fair as possible.
