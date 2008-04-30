Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYD3Jzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYD3Jzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYD3JzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:55:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50608 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYD3JzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:55:23 -0400
Date: Wed, 30 Apr 2008 11:55:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, mchehab@infradead.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430095557.GA31986@uranus.ravnborg.org>
References: <20080429185009.716c3284@gaivota> <20080430074807.GA11224@elte.hu> <20080430.005212.46815036.davem@davemloft.net> <20080430081345.GA16519@elte.hu> <20080430092500.GA31644@uranus.ravnborg.org> <20080430093728.GA3568@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430093728.GA3568@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:37:28AM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > drivers/media is special because it does not contain any files. Kbuild 
> > will generate a built-in.o file only if there is a chance for a .o 
> > file in the directory.
> > 
> > When all media is modules kbuild does not know enough to say that a 
> > built-in.o is needed in drivers/media/ and the workaround to do a 
> > obj-y := common/ is the best way to do so.
> 
> ok, good. Should be an exceedingly rare situation, we dont have _that_ 
> many driver sub-trees.
> 
> Can we take this as a:
> 
>   Acked-by: Sam Ravnborg <sam@ravnborg.org>
Yes.

	Sam
