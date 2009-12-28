Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZL1HJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZL1HJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZL1HJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:09:32 -0500
Received: from www84.your-server.de ([213.133.104.84]:44545 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZL1HJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:09:32 -0500
Subject: Re: [PATCH] [4/6] kfifo: add kfifo_out_peek
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227234137.GD2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210314.ABA04B17C3@basil.firstfloor.org>
	 <1261950589.25298.32.camel@wall-e>  <20091227234137.GD2399@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Dec 2009 08:09:26 +0100
Message-ID: <1261984166.31031.20.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 28.12.2009, 00:41 +0100 schrieb Andi Kleen:
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
> 
> I hope it's not all abandonware.
> 

As i wrote: Yes and No. I would like to sedd the merged kfifo interface
which the new macro based. The API is still compatible but the code is
completely changed.

Stefani


