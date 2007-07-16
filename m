Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbXGPWwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbXGPWwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXGPWwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:52:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58362
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbXGPWwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:52:46 -0400
Date: Mon, 16 Jul 2007 15:52:48 -0700 (PDT)
Message-Id: <20070716.155248.123922659.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0707161525250.20061@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
	<20070716.150825.66176632.davem@davemloft.net>
	<alpine.LFD.0.999.0707161525250.20061@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jul 2007 15:29:15 -0700 (PDT)

> If we knew something was wrong before the -rc1 release, all the better: we 
> can avoid havign that bug in -rc1, and the people who test it will tell us 
> about the problems we did *not* know about.
> 
> In contrast, if we leave a known bug in, that will just mean that other 
> problems won't be found either, because people get hung up on the known 
> bug.

Fair enough.
