Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbXLPVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbXLPVnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXLPVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:43:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39476
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758241AbXLPVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:43:07 -0500
Date: Sun, 16 Dec 2007 13:42:58 -0800 (PST)
Message-Id: <20071216.134258.150452499.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6.25 1/8] Create ipv4_is_<type>(__be32 addr)
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197589141-7020-1-git-send-email-joe@perches.com>
References: <1197589141-7020-1-git-send-email-joe@perches.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 13 Dec 2007 15:38:54 -0800

> Change IPV4 specific macros LOOPBACK MULTICAST LOCAL_MCAST BADCLASS and ZERONET
> macros to inline functions ipv4_is_<type>(__be32 addr)
> 
> Adds type safety and arguably some readability.
> 
> Changes since last submission:
> 
> Removed ipv4_addr_octets function
> Used hex constants
> Converted recently added rfc3330 macros
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
