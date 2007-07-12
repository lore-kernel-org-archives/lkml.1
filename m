Return-Path: <linux-kernel-owner+w=401wt.eu-S935156AbXGLC2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156AbXGLC2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbXGLC2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:28:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47592
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756665AbXGLC2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:28:06 -0400
Date: Wed, 11 Jul 2007 19:28:29 -0700 (PDT)
Message-Id: <20070711.192829.08323972.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
From: David Miller <davem@davemloft.net>
In-Reply-To: <1184203311.6005.664.camel@localhost.localdomain>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711122324.GA21714@lst.de>
	<1184203311.6005.664.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Jul 2007 11:21:51 +1000

> To do inter-guest (ie. inter-process) I/O you really have to make sure
> the other side doesn't go away.

You should just let it exit and when it does you receive some kind of
exit notification that resets your virtual device channel.

I think the reference counting approach is error and deadlock prone.
Be more loose and let the events reset the virtual devices when
guests go splat.
