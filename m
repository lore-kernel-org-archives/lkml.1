Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbXBMS2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbXBMS2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXBMS2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:28:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4796 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751493AbXBMS2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:28:23 -0500
Date: Mon, 12 Feb 2007 12:19:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212121934.GA5226@ucw.cz>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no> <fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no> <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no> <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no> <fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no> <45CF60F2.5020308@shaw.ca> <20070211215211.GB13913@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211215211.GB13913@1wt.eu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I think your experience is rather different than that of Joe Average 
> > User who doesn't frequent kernel lists, and also I think you'll find 
> > that for a lot of Linux laptop users that don't use supend, the reason 
> > is that it doesn't work reliably, quite often due to driver issues.
> 
> I would believe it if I knew people using suspend/resume on the other OS.
> But that's not the case either. Also, it happens that with today's RAM
> sizes, suspend-to-disk then resume can be several times slower than a
> clean fresh boot. When you have 1 GB to write at 20 MB/s, it takes 50

Stop spreading FUD. swsusp only saves _used_ memory, not all memory,
so it indeed should be faster these days. And yes, it supports
encryption these days.

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
