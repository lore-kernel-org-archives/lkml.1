Return-Path: <linux-kernel-owner+w=401wt.eu-S1764898AbYDON7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764898AbYDON7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYDON7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:59:22 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2439 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYDON7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:59:21 -0400
Date: Tue, 15 Apr 2008 09:28:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: Re: w35und: add softmac interface
Message-ID: <20080415132845.GA11789@tuxdriver.com>
References: <20080414224740.GA31431@elf.ucw.cz> <20080415002826.GC4270@tuxdriver.com> <20080415070923.GA13767@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415070923.GA13767@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 09:22:41AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > This adds softmac interface to w35und driver... so it becomes monster
> > > driver with _two_ interfaces.
> > > 
> > > If you initialize hardmac interface, then softmac starts to
> > > works... it associates to AP, and can even ping.
> > > 
> > > (Or at least I hope so... it was somewhat too easy.)
> > 
> > OK, I'm late to the party...what is this stuff going into
> > drivers/net/wireless?
> 
> Actually you are about month early to the party ;-). We are trying to
> clean up winbond usb wireless driver, so that it can think about
> inclusion in kernel.
> 
> http://code.google.com/p/winbondport/
> 
> Unfortunately, original driver carries its own 802.11 stack with it;
> that needs to be stripped down. (And then code needs to be rewritten
> due to horrible coding style).

I see...OK.

Did you get any legal advice regarding whether or not
MODULE_LICENSE("GPL") was sufficient to proclaim the driver as covered
by the GPL?

John
-- 
John W. Linville
linville@tuxdriver.com
