Return-Path: <linux-kernel-owner+w=401wt.eu-S935849AbXGLCvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935849AbXGLCvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932811AbXGLCvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:51:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46256
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765048AbXGLCvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:51:04 -0400
Date: Wed, 11 Jul 2007 19:51:26 -0700 (PDT)
Message-Id: <20070711.195126.02300228.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
From: David Miller <davem@davemloft.net>
In-Reply-To: <1184208521.6005.695.camel@localhost.localdomain>
References: <1184203311.6005.664.camel@localhost.localdomain>
	<20070711.192829.08323972.davem@davemloft.net>
	<1184208521.6005.695.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Jul 2007 12:48:41 +1000

> We drop the lock after I/O, and then do this wakeup.  Meanwhile the
> other task might have exited.

I already understand what you're doing.

Is it possible to use exit notifiers to handle this case?
That's what I'm trying to suggest. :)
