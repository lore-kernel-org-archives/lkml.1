Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbXGPL0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbXGPL0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXGPL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:26:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54936
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbXGPL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:26:38 -0400
Date: Mon, 16 Jul 2007 04:26:40 -0700 (PDT)
Message-Id: <20070716.042640.18306462.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070716091236.GA10718@elte.hu>
References: <20070716091236.GA10718@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 16 Jul 2007 11:12:36 +0200

> Applying the revert patch below makes it work again.

Well, let's figure out why before we revert because it
is attempting to fix a legitimate bug.

Olaf, any ideas?
