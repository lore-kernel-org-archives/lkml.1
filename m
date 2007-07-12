Return-Path: <linux-kernel-owner+w=401wt.eu-S1765092AbXGLDf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765092AbXGLDf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbXGLDfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:35:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48045
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755422AbXGLDfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:35:19 -0400
Date: Wed, 11 Jul 2007 20:35:18 -0700 (PDT)
Message-Id: <20070711.203518.59469474.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
From: David Miller <davem@davemloft.net>
In-Reply-To: <1184210118.6005.719.camel@localhost.localdomain>
References: <1184208521.6005.695.camel@localhost.localdomain>
	<20070711.195126.02300228.davem@davemloft.net>
	<1184210118.6005.719.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Jul 2007 13:15:18 +1000

> Sure, the process has /dev/lguest open, so I can do something in the
> close routine.  Instead of keeping a reference to the tsk, I can keep a
> reference to the struct lguest (currently it doesn't have or need a
> refcnt).  Then I need another lock, to protect lg->tsk.
> 
> This seems like a lot of dancing to avoid one export.  If it's that
> important I'd far rather drop the code and do a normal wakeup under the
> big lguest lock for 2.6.23.

I'm not against the export, so use if it really helps.

Ref-counting just seems clumsy to me given how the hw assisted
virtualization stuff works on platforms I am intimately familiar with
:)
