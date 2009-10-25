Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZJYIMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZJYIMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZJYIMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:12:31 -0400
Received: from www84.your-server.de ([213.133.104.84]:38587 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZJYIM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:12:28 -0400
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>
In-Reply-To: <20091025014831.GC32470@one.firstfloor.org>
References: <1256391194.7362.7.camel@wall-e>
	 <20091025014831.GC32470@one.firstfloor.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 09:12:24 +0100
Message-Id: <1256458344.4026.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 25.10.2009, 02:48 +0100 schrieb Andi Kleen:
> On Sat, Oct 24, 2009 at 03:33:14PM +0200, Stefani Seibold wrote:
> > This is a new generic kernel FIFO implementation.
> > 
> > The current kernel fifo API is not very widely used, because it has to many
> > constrains. Only 17 files in the current 2.6.31-rc5 used it. FIFO's are
> > like list's a very basic thing and a kfifo API which handles the most use
> > case would save a lot of development time and memory resources.
> > 
> > I think this are the reasons why kfifo is not in use:
> > 
> > - The API is to simple, important functions are missing
> > - A fifo can be only allocated dynamically
> > - There is a need of a spinlock despite you need it or not
> > - There is no support for data records inside a fifo
> 
> I have some plans to use this kfifo code in upcoming code (mostly
> as a very simple lower overhead NMI safe per CPU fifo). I would appreciate 
> if it could be merged ASAP
> 
> I didn't review this iteration, but earlier ones.
> 

There was no modification in the code since the last version. I added
only the function kfifo_avail_rec which has no site effect to the rest
of the code.

> Acked-by: Andi Kleen <ak@linux.intel.com>
> 
> -Andi

Stefani


