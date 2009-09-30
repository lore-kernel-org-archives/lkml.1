Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZI3MDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZI3MDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZI3MDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:03:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46564 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbZI3MDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:03:34 -0400
Date: Wed, 30 Sep 2009 14:03:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hibernation oops with 2.6.31 won't fit the screen - how to
	debug?
Message-ID: <20090930120327.GC1412@ucw.cz>
References: <200909192155.01225.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909192155.01225.linux@rainbow-software.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-09-19 21:55:00, Ondrej Zary wrote:
> Hello,
> hibernation worked great with 2.6.30 - I had over a month of uptime (it never 
> worked so well before - always crashed after some time). But in 2.6.31, it's 
> broken again - and completely. The first hibernation works but it always 
> crashes on the second one.
> 
> The problem is that the oops is so long that it does not fit the screen - even 
> 1280x1024 is not enough. Scrolling does not work (as it used to do on 2.4 
> kernels), netconsole does not catch it. So how can I debug this?

I see you solved that already but... vga=6 and mdelay(1000) in
printk/oops code is canonical way to debug that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
