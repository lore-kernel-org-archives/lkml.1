Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZJRQ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZJRQ1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZJRQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:27:34 -0400
Received: from foo.birdnet.se ([213.88.146.6]:48254 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750948AbZJRQ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:27:34 -0400
Message-ID: <20091018162737.18611.qmail@stuge.se>
Date: Sun, 18 Oct 2009 18:27:37 +0200
From: Peter Stuge <peter@stuge.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hardware initialization in line discipline - ldisc_open() ?
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <20091015205803.30544.qmail@stuge.se> <20091015223137.6b9fb55a@lxorguk.ukuu.org.uk> <20091015214642.6208.qmail@stuge.se> <20091015230853.44fb10c1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015230853.44fb10c1@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > > Similar problem with the GSM mux I've been working on. I've gone for
> > > making the ldisc attach always work and then kicking things off via an
> > > ioctl which sets the desired mode/parameters/encoding.
> > 
> > I'll do the same. Did you add a new ioctl for this, or use an
> > existing one?
> 
> I added a private one - given I needed to pass the adaption layer code,
> gsm mux level and whether we were initiator or not it didn't really fit
> anything generic in the tty layer.

I was trying to reuse an existing ioctl, partly because I'm not sure
how to add a one and partly because fewer are better, but
TIOCSERCONFIG which seemed fitting does not appear to be passed on to
my ldisc. :\

Should I make a new one (what does private mean here btw?) and how do
I do it exactly? Is patching Documentation/ioctl/ioctl-number.txt and
asm/ioctls.h all? The "addressing" in ioctl-number seems a little
chaotic, do I just pick anything that is available?


//Peter
