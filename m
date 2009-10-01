Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZJATn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZJATn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbZJATnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:43:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49161
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259AbZJATnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:43:24 -0400
Date: Thu, 01 Oct 2009 12:43:44 -0700 (PDT)
Message-Id: <20091001.124344.88736363.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-10-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091001182450.GD2895@tuxdriver.com>
References: <20091001182450.GD2895@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 1 Oct 2009 14:24:51 -0400

> One is a brown paper bag fix for an uninitialized variable, another is a
> USB ID.  There is a beaconing fix for the mac80211_hwsim "fake" driver,
> and a bug fix for AP mode related to buffering frames for stations in
> power save mode.
> 
> The b43 fix looks a bit long, but it is more-or-less the same simple
> fix applied in multiple places.  It addresses a bug where "the last
> bytes of data sent/received to/from PIO FIFOs on SDIO-based cards get
> 'swizzled' when its length is not multiple of 4 bytes."
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.

I'll try to make sure the netif_rx_ni() et al. discussion keeps
making forward progress so that will get fixed too :-)
