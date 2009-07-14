Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZGNT1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZGNT1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZGNT1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:27:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43241
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756094AbZGNT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:27:13 -0400
Date: Tue, 14 Jul 2009 12:27:17 -0700 (PDT)
Message-Id: <20090714.122717.167640290.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] NET: phy_device, fix lock imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247520220-31960-1-git-send-email-jirislaby@gmail.com>
References: <1247520220-31960-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Mon, 13 Jul 2009 23:23:39 +0200

> Don't forget to unlock a mutex in phy_scan_fixups on a fail path.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied.
