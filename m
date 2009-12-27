Return-Path: <linux-kernel-owner+w=401wt.eu-S1751462AbZL0Xic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbZL0Xic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZL0XiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:38:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59251 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZL0XiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:38:17 -0500
Date: Mon, 28 Dec 2009 00:38:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091227233816.GC2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <1261949800.25298.18.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261949800.25298.18.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 10:36:40PM +0100, Stefani Seibold wrote:
> Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> > While porting some of my code to kfifo I found some issues, which
> > are addressed in the following patch series.
> > 
> > Some of the problems were serious, particularly the non atomic kfifo_in()
> > problem. That's probably 2.6.33 material at least. 
> > 
> 
> I am not happy to see you to take over my project. Especial as most of

I'm just trying to use kfifos and ran into lots of issues that
I fixed. Especially the non atomic kfifo_in problem seemed pretty fatal
BTW.

> your fixes are part of my new macro based implementation. Have a look at
> http://patchwork.kernel.org/patch/69093/

Even if that was merged the older interfaces still need to be fixed.

Or are you saying the new interface would completely replace kfifos?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
