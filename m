Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbYGXJcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbYGXJcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYGXJcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:32:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52669
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbYGXJcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:32:10 -0400
Date: Thu, 24 Jul 2008 02:32:10 -0700 (PDT)
Message-Id: <20080724.023210.229338550.davem@davemloft.net>
To: peterz@infradead.org
Cc: jarkao2@gmail.com, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com,
       nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216891625.7257.261.camel@twins>
References: <1216890648.7257.258.camel@twins>
	<20080724.022040.23129457.davem@davemloft.net>
	<1216891625.7257.261.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 24 Jul 2008 11:27:05 +0200

> Well, not only lockdep, taking a very large number of locks is expensive
> as well.

Right now it would be on the order of 16 or 32 for
real hardware.

Much less than the scheduler currently takes on some
of my systems, so currently you are the pot calling the
kettle black. :-)

USHORT_MAX is just the upper hard limit imposed by the
software interface merely as a side effect of storing
the queue number of the SKB as a u16.
