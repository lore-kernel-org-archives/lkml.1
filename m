Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYBYGtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYBYGtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYBYGtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:49:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57151 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYBYGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:49:13 -0500
Date: Sun, 24 Feb 2008 22:49:35 -0800
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Michael Buesch <mb@bu3sch.de>, Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Alexey Zaytsev <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080225064935.GA20997@kroah.com>
References: <47BEAF3B.3080809@protei.ru> <200802241529.50967.mb@bu3sch.de> <f19298770802240839w2c19fd52vb0d170359ba56fc5@mail.gmail.com> <200802241816.01784.mb@bu3sch.de> <Pine.LNX.4.64.0802250814450.10065@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802250814450.10065@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 08:16:17AM +0200, Pekka J Enberg wrote:
> Hi Michael,
> 
> On Sun, 24 Feb 2008, Michael Buesch wrote:
> > > The ony way I see this was possible, you manually changed the
> > > module loading order, so that the b43xx module was loaded prior
> > > to the ssb and b44 modules. Right?
> > 
> > Right. So "so I'm left with either no wifi or no ethenet" being wrong.
> 
> Lets make this simple: it used to work before and now it doesn't. 
> Therefore it's a regression that must be addressed. Period.

Isn't the resolution Michael is suggesting is, "use the different driver"?

thanks,

greg k-h
