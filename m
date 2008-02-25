Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYBYJzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYBYJzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYBYJzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:55:41 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:41013 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYBYJzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:55:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Mon, 25 Feb 2008 10:54:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Zaytsev <zaytsev.a@protei.ru>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <47BEAF3B.3080809@protei.ru> <Pine.LNX.4.64.0802250814450.10065@sbz-30.cs.Helsinki.FI> <20080225064935.GA20997@kroah.com>
In-Reply-To: <20080225064935.GA20997@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251054.57070.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 07:49:35 Greg KH wrote:
> On Mon, Feb 25, 2008 at 08:16:17AM +0200, Pekka J Enberg wrote:
> > Hi Michael,
> > 
> > On Sun, 24 Feb 2008, Michael Buesch wrote:
> > > > The ony way I see this was possible, you manually changed the
> > > > module loading order, so that the b43xx module was loaded prior
> > > > to the ssb and b44 modules. Right?
> > > 
> > > Right. So "so I'm left with either no wifi or no ethenet" being wrong.
> > 
> > Lets make this simple: it used to work before and now it doesn't. 
> > Therefore it's a regression that must be addressed. Period.
> 
> Isn't the resolution Michael is suggesting is, "use the different driver"?

I have two resolutions. One being:
rmmod b44
rmmod ssb
modprobe bcm43xx
modprobe b44

The other being: Wait for 2.6.25 and use the maintained b43 driver.

-- 
Greetings Michael.
