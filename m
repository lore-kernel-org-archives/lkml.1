Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZI1T5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZI1T5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZI1T5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:57:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41246
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbZI1T5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:57:38 -0400
Date: Mon, 28 Sep 2009 12:57:57 -0700 (PDT)
Message-Id: <20090928.125757.151682793.davem@davemloft.net>
To: arjan@infradead.org
Cc: gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] Add explicit bound checks in net/socket.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090926212302.0ce64a5c@infradead.org>
References: <20090926205432.24aa1023@infradead.org>
	<20090926190103.GB4356@lenovo>
	<20090926212302.0ce64a5c@infradead.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Sat, 26 Sep 2009 21:23:02 +0200

> The sys_socketcall() function has a very clever system for the copy
> size of its arguments. Unfortunately, gcc cannot deal with this in
> terms of proving that the copy_from_user() is then always in bounds.
> This is the last (well 9th of this series, but last in the kernel) such
> case around.
> 
> With this patch, we can turn on code to make having the boundary provably
> right for the whole kernel, and detect introduction of new security
> accidents of this type early on.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Applied, thanks.
