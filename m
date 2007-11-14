Return-Path: <linux-kernel-owner+w=401wt.eu-S1764142AbXKNXlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764142AbXKNXlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbXKNXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:41:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50389
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbXKNXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:41:44 -0500
Date: Wed, 14 Nov 2007 15:41:43 -0800 (PST)
Message-Id: <20071114.154143.112110604.davem@davemloft.net>
To: mpm@selenic.com
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071114233713.GW19691@waste.org>
References: <20071114225335.GV19691@waste.org>
	<20071114.151013.05582536.davem@davemloft.net>
	<20071114233713.GW19691@waste.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Wed, 14 Nov 2007 17:37:13 -0600

> No, the usual strategy for debugging problems -outside- SLOB is to
> switch to another allocator with more extensive debugging facilities.

Ok, so the thing we still can do is do a dump_stack() at the
list debugging assertion trigger points.
