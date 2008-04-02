Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbYDBSqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbYDBSqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761708AbYDBSpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:45:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50461
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760841AbYDBSpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:45:45 -0400
Date: Wed, 02 Apr 2008 11:45:45 -0700 (PDT)
Message-Id: <20080402.114545.17950613.davem@davemloft.net>
To: peterz@infradead.org
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       csnook@redhat.com, davej@codemonkey.org.uk, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: GFP_ATOMIC page allocation failures.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1207134299.8514.771.camel@twins>
References: <20080402171104.9591.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080402.012406.246863209.davem@davemloft.net>
	<1207134299.8514.771.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 02 Apr 2008 13:04:59 +0200

> Would we not hope that most net drivers can handle {,net}dev_alloc_skb()
> failing? Otherwise we have some serious trouble.

False presumption.

Most can but some legacy ones really do not handle this well.

