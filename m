Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYFTWr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYFTWr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYFTWrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:47:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45109
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbYFTWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:47:16 -0400
Date: Fri, 20 Jun 2008 15:47:16 -0700 (PDT)
Message-Id: <20080620.154716.75920403.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806201833200.25997@engineering.redhat.com>
References: <Pine.LNX.4.64.0806201819430.25997@engineering.redhat.com>
	<20080620.152847.169209890.davem@davemloft.net>
	<Pine.LNX.4.64.0806201833200.25997@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 20 Jun 2008 18:36:09 -0400 (EDT)

> On Fri, 20 Jun 2008, David Miller wrote:
> 
> > Yes for debugging and other things it has to stay.
> 
> If you want it to stay, then it doesn't make sense to make functions 
> tail-call-friendly --- because it should not crash with or without 
> debugging.

On the contrary, of course it makes sense to do so.

When debugging is disabled, the kernel will run faster.

We have to fix the stack usage in either case, but from a
performance standpoint when debugging is disabled the
tail-call friendly layout is still highly desirable.
