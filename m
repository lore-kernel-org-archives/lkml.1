Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbYHLGa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbYHLGa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYHLGaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:30:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43452
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbYHLGaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:30:12 -0400
Date: Mon, 11 Aug 2008 23:30:13 -0700 (PDT)
Message-Id: <20080811.233013.49328708.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
References: <20080620.144128.32005196.davem@davemloft.net>
	<20080620.215139.218732028.davem@davemloft.net>
	<Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sat, 21 Jun 2008 15:42:56 -0400 (EDT)

> On Fri, 20 Jun 2008, David Miller wrote:
> 
> > giving a try.
> >
> > sparc64: Implement support for IRQ stacks.
> 
> For me it doesn't work. Locked up after "console: colour dummy device 
> 80x25".

Are you sure you didn't see a "Stack overflow" message on the
screen? :-)

That's what I get when I try to boot with your provided
kernel config.

The problem is that CONFIG_STACK_DEBUG doesn't understand
the IRQ stacks at all.

I'll see if I can tweak it to handle this.
