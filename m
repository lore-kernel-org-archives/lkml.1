Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZJYBs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZJYBs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 21:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZJYBs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 21:48:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36625 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZJYBs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 21:48:27 -0400
Date: Sun, 25 Oct 2009 02:48:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
Message-ID: <20091025014831.GC32470@one.firstfloor.org>
References: <1256391194.7362.7.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256391194.7362.7.camel@wall-e>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 03:33:14PM +0200, Stefani Seibold wrote:
> This is a new generic kernel FIFO implementation.
> 
> The current kernel fifo API is not very widely used, because it has to many
> constrains. Only 17 files in the current 2.6.31-rc5 used it. FIFO's are
> like list's a very basic thing and a kfifo API which handles the most use
> case would save a lot of development time and memory resources.
> 
> I think this are the reasons why kfifo is not in use:
> 
> - The API is to simple, important functions are missing
> - A fifo can be only allocated dynamically
> - There is a need of a spinlock despite you need it or not
> - There is no support for data records inside a fifo

I have some plans to use this kfifo code in upcoming code (mostly
as a very simple lower overhead NMI safe per CPU fifo). I would appreciate 
if it could be merged ASAP

I didn't review this iteration, but earlier ones.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
