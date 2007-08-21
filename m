Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbXHUHZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbXHUHZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXHUHZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:25:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbXHUHZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:25:07 -0400
Date: Tue, 21 Aug 2007 00:24:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708210016420.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>
 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
 <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
 <200708202334.38261.david-b@pacbell.net>
 <alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, Linus Torvalds wrote:
> 
> On Mon, 20 Aug 2007, David Brownell wrote:
> > 
> > Try disabling USB_SUSPEND ... the rather aggressive powersave
> > mechanism (autosuspend defaulting to always ON) has made lots
> > of trouble.  I think that default will change...
> 
> It's already disabled - so that's not it.

Side note: after reverting 196705c9bb I can't get the mouse to skip any 
more on that mac mini. But since the bad behaviour wasn't 100% reliable to 
begin with, that's not really a guarantee of anything. Two out of three 
kids are off on camp this week, so that machine probably won't be getting 
a lot of testing ;/

That's with an all-intel chipset, no VIA or Broadcom anywhere.

I do find it interesting that VIA apparently ignores the INACTIVE bit: it 
implies that Windows probably doesn't use it, which in turn implies that 
nobody has ever tested it in any real life situation. So I would not be 
shocked to hear that others have problems too.

But as mentioned, the mouse behaviour was flaky (but very noticeable and 
irritating when it did happen), so it's hard to be sure my quick testing 
really was convincing. Which is why it's even harder to bisect ;(.

			Linus
