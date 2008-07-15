Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbYGOBu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbYGOBu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYGOBuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:50:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45053
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbYGOBuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:50:12 -0400
Date: Mon, 14 Jul 2008 18:50:12 -0700 (PDT)
Message-Id: <20080714.185012.245476473.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: david@lang.hm, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
References: <20080714165956.7fe2d4ee@infradead.org>
	<alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	<alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Jul 2008 17:33:58 -0700 (PDT)

> The only reliable way to handle it is to load the firmware before the 
> suspend happens - preferably by simply never unloading it in the first 
> place.

That's what we were told was the huge benefit of moving some
of these drivers over to this request_firmware() stuff, it would
save memory.

To me, especially for the networking drivers for which I am familiar,
this transformation seems completely pointless from a technical
perspective.  In fact it's a regression as-is.

