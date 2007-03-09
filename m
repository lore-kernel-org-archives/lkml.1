Return-Path: <linux-kernel-owner+w=401wt.eu-S2993051AbXCIH0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993051AbXCIH0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993054AbXCIH0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:26:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46268
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2993047AbXCIH0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:26:42 -0500
Date: Thu, 08 Mar 2007 23:26:41 -0800 (PST)
Message-Id: <20070308.232641.74749402.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       christopher.leech@intel.com
Subject: Re: [PATCH 0/2] NET: Multiple queue network device support REPOST
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329026E982F@orsmsx414.amr.corp.intel.com>
References: <20070308.231142.74749203.davem@davemloft.net>
	<D5C1322C3E673F459512FB59E0DDC329026E982F@orsmsx414.amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Date: Thu, 8 Mar 2007 23:16:58 -0800

> It seems expensive to change all the skb's if this type of
> event occurs,

The reset functions have to walk all the SKBs anyways.
