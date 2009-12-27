Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZL0Xll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZL0Xll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbZL0Xlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:41:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58143 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZL0Xlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:41:39 -0500
Date: Mon, 28 Dec 2009 00:41:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] [4/6] kfifo: add kfifo_out_peek
Message-ID: <20091227234137.GD2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <20091227210314.ABA04B17C3@basil.firstfloor.org> <1261950589.25298.32.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261950589.25298.32.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 10:49:49PM +0100, Stefani Seibold wrote:
> Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> > In some upcoming code it's useful to peek into a FIFO without
> > permanentely removing data. This patch implements a new 
> > kfifo_out_peek() to do this. 
> > 
> 
> Yes this function can be useful. I will implement it in the macro
> version of the kfifo.

Well that doesn't help me -- I need a working kfifo on a 2.6.33
base. Or do you want to abandon the old interface?

I must say I'm a little surprised by the general tone of  
your comments -- first you submit these patches all the time and when they 
finally get reviewed and merged and people start to use them and make them 
production ready you state it's all abandoned.

I hope it's not all abandonware.

Anyways Andrew could you please merge these fixes? Thanks.

-Andi
