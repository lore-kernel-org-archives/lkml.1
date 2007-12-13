Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbXLMOTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbXLMOTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXLMOTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:19:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42672
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbXLMOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:19:39 -0500
Date: Thu, 13 Dec 2007 06:19:38 -0800 (PST)
Message-Id: <20071213.061938.86541759.davem@davemloft.net>
To: gallatin@myri.com
Cc: joonwpark81@gmail.com, auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <47613E22.6060705@myri.com>
References: <47602B77.2090202@intel.com>
	<b25c3fa70712122341q3ba282cdqda3fa56901b14484@mail.gmail.com>
	<47613E22.6060705@myri.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Gallatin <gallatin@myri.com>
Date: Thu, 13 Dec 2007 09:13:54 -0500

> If the netif_running() check is indeed required to make a device break
> out of napi polling and respond to an ifconfig down, then I think the
> netif_running() check should be moved up into net_rx_action() to avoid
> potential for driver complexity and bugs like the ones you found.

That, or something like it, definitely sounds reasonable and much
better than putting the check into every driver :-)
