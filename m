Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914Ab0ADV6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0ADV6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0ADV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:58:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867Ab0ADV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:58:10 -0500
Date: Mon, 4 Jan 2010 13:57:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/6] kfifo: add kfifo_out_peek
Message-Id: <20100104135754.07d4e442.akpm@linux-foundation.org>
In-Reply-To: <20091227234137.GD2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	<20091227210314.ABA04B17C3@basil.firstfloor.org>
	<1261950589.25298.32.camel@wall-e>
	<20091227234137.GD2399@basil.fritz.box>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 00:41:37 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Sun, Dec 27, 2009 at 10:49:49PM +0100, Stefani Seibold wrote:
> > Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> > > In some upcoming code it's useful to peek into a FIFO without
> > > permanentely removing data. This patch implements a new 
> > > kfifo_out_peek() to do this. 
> > > 
> > 
> > Yes this function can be useful. I will implement it in the macro
> > version of the kfifo.
> 
> Well that doesn't help me -- I need a working kfifo on a 2.6.33
> base. Or do you want to abandon the old interface?
> 
> I must say I'm a little surprised by the general tone of  
> your comments -- first you submit these patches all the time and when they 
> finally get reviewed and merged and people start to use them and make them 
> production ready you state it's all abandoned.

Yup, the first priority is to get the 2.6.33 code fixed up.  It is
unwise to assume that we'll be merging some other patch some time in
the future.

Macros are unpopular, for good reasons.  But the case for a
template-based container such as this is a good one.  However I worry
about the code bloat whcih the macro version might add.  We worry about
all this later on.

> 
> Anyways Andrew could you please merge these fixes? Thanks.

I shall.  Stefani, pelase review those patches for 2.6.33 suitability. 
Let's not worry about a big rewrite at this time.

