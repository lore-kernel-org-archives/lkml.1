Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbXHPOdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbXHPOdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbXHPOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:33:25 -0400
Received: from stinky.trash.net ([213.144.137.162]:34162 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbXHPOdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:33:25 -0400
Message-ID: <46C45FFB.3050609@trash.net>
Date: Thu, 16 Aug 2007 16:32:27 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       netfilter-devel@lists.netfilter.org
Subject: Re: [PATCH 6/6] netfilter: xt_u32: fix length checks in u32_match_it
References: <exportbomb.1187270320@pinky> <3a5bf48d1567d7136baaac80dfa4c94f@pinky>
In-Reply-To: <3a5bf48d1567d7136baaac80dfa4c94f@pinky>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> It seems an extraneous trailing ';' has slipped into the skb length
> checks in u32_match_it() triggering an unconditional missmatch.


Thanks, this already fixed in net-2.6 and should hit Linus' tree soon.
