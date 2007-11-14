Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbXKNWjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbXKNWjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXKNWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:39:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55094
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbXKNWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:39:39 -0500
Date: Wed, 14 Nov 2007 14:39:38 -0800 (PST)
Message-Id: <20071114.143938.23516450.davem@davemloft.net>
To: mingo@elte.hu
Cc: mpm@selenic.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071114190501.GA5768@elte.hu>
References: <20071114173611.GR19691@waste.org>
	<20071114183952.GS19691@waste.org>
	<20071114190501.GA5768@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Nov 2007 20:05:01 +0100

> the bug went away - and the only thing i did was a networking config 
> tweak. So maybe something in networking corrupts memory?

This wouldn't surprise me at all.

I think we can make some headway on this bug, the next time
you trigger it, if the list debugging was a little less terse.

For example, a backtrace and perhaps even feeding the bad list
pointers in question to the SLAB/SLUB debug helpers that can
identify a kmem cache from a given pointer would help.

Thanks.
