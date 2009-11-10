Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZKJLZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZKJLZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZKJLZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:25:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36566 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZKJLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:25:58 -0500
Date: Tue, 10 Nov 2009 11:53:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       KMoorman@transy.edu, w.sang@pengutronix.de,
       ken_kawasaki@spring.nifty.jp, davem@davemloft.net,
       Andrew Morton <akpm@osdl.org>
Subject: Re: serial_cs: oxsemi quirk breaks resume
Message-ID: <20091110105305.GA1353@ucw.cz>
References: <20091110075410.GA6157@ucw.cz> <20091110103259.6050db7e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110103259.6050db7e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-10 10:32:59, Alan Cox wrote:
> On Tue, 10 Nov 2009 08:54:11 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > 
> > Quirk is applied on all cards with given manfid (is it that
> > correct?). Unfortunately, that quirk breaks resume on zaurus with
> > billionton bluetooth card inserted: c950ctrl is 0 and outb() faults.
> 
> So how does it end up as zero, do you have a race between insert/remove
> somewhere ?

It does not look like race. I believe it is simply not a multiport
card. (info->multi == 1). ... ... confirmed by printks.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
