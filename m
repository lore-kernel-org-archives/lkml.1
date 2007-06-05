Return-Path: <linux-kernel-owner+w=401wt.eu-S1763412AbXFEGxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763412AbXFEGxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbXFEGxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:53:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35660
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755205AbXFEGw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:52:59 -0400
Date: Mon, 04 Jun 2007 23:53:13 -0700 (PDT)
Message-Id: <20070604.235313.85409993.davem@davemloft.net>
To: sam@ravnborg.org
Cc: adaplas@gmail.com, jakub@redhat.com, jengelh@linux01.gwdg.de,
       daplas@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Section mismatches in drivers/video/console/promcon
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070602191646.GA13264@uranus.ravnborg.org>
References: <20070602124255.GA10119@uranus.ravnborg.org>
	<1180790683.4524.13.camel@daplas>
	<20070602191646.GA13264@uranus.ravnborg.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 2 Jun 2007 21:16:46 +0200

> > 
> > promcon_init() can be called again from visual_init() during
> > vc_allocate().  So anything referenced by promcon_init() should not be
> > marked __init.
> > 
> > Although, if you want to keep promfont_unitable and promfont_unicount
> > __init, you can probably use con_copy_unimap() using the default vc as
> > the source instead of doing a promcon_init_unimap() again.
> 
> Too involved for me to look into.
> I cooked up following very minimal patch - if you agree can you then please
> forward/take care of it.
> 
> 	Sam
> 
> Subject: video: fix section mismatch warning in promcon

I'll merge this fix in via the Sparc tree since this is a sparc
console driver.

Thanks Sam.
