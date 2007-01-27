Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbXA0RTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbXA0RTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXA0RTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:19:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2684 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751940AbXA0RTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:19:24 -0500
Date: Sat, 27 Jan 2007 17:19:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-ID: <20070127171914.GC3942@ucw.cz>
References: <20061219185223.GA13256@srcf.ucam.org> <200612201318.06976.david-b@pacbell.net> <20061221012924.GC32625@srcf.ucam.org> <200612201904.28681.david-b@pacbell.net> <20061221040648.GA1499@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org> <20070126115905.66940ac9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126115905.66940ac9.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This patch allows the bus driver to check whether a specific driver 
> > requires the split. If not, the 2.6.18 functionality is restored. It 
> > also alters feature-removals.txt to note that the deprecated 
> > functionality should not be removed until a replacement actually exists.
> 
> That sounds like material for 2.6.20 as well as for 2.6.19.x.

No. It re-enbles mechanism that never worked properly and that is
known to oops the kernels.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
