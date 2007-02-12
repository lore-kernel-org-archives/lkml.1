Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbXBMS2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbXBMS2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXBMS2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:28:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4794 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751492AbXBMS2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:28:22 -0500
Date: Mon, 12 Feb 2007 14:32:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Con Kolivas <kernel@kolivas.org>
Cc: Vassili Karpov <av1474@comtv.ru>, linux-kernel@vger.kernel.org
Subject: Re: CPU load
Message-ID: <20070212143219.GB5226@ucw.cz>
References: <loom.20070212T063225-663@post.gmane.org> <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The kernel looks at what is using cpu _only_ during the 
> timer
> interrupt. Which means if your HZ is 1000 it looks at 
> what is running
> at precisely the moment those 1000 timer ticks occur. It 
> is
> theoretically possible using this measurement system to 
> use >99% cpu
> and record 0 usage if you time your cpu usage properly. 
> It gets even
> more inaccurate at lower HZ values for the same reason.

I have (had?) code that 'exploits' this. I believe I could eat 90% of cpu
without being noticed.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
