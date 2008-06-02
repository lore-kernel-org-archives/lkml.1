Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYFBFjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYFBFjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYFBFjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:39:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50065
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbYFBFjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:39:42 -0400
Date: Sun, 01 Jun 2008 22:39:38 -0700 (PDT)
Message-Id: <20080601.223938.193701581.davem@davemloft.net>
To: billfink@mindspring.com
Cc: bhutchings@solarflare.com, alan@lxorguk.ukuu.org.uk, jimi@sngx.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080601164614.012fe1f6.billfink@mindspring.com>
References: <20080531195702.0b879dd1.billfink@mindspring.com>
	<20080601014620.GG30769@solarflare.com>
	<20080601164614.012fe1f6.billfink@mindspring.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Fink <billfink@mindspring.com>
Date: Sun, 1 Jun 2008 16:46:14 -0400

> Another issue that occurred to me is if multiple people are working
> on troubleshooting a network problem, how do we insure that they all
> get a consistent view of the stats?

Some of them definitely won't get a consistent view if one of them
triggers this undesirable statistic clearing knob.
