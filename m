Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYDFX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYDFX2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 19:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYDFX2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 19:28:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37025 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbYDFX2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 19:28:11 -0400
Date: Mon, 7 Apr 2008 01:28:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspend issue
Message-ID: <20080406232849.GA789@elf.ucw.cz>
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com> <1207490104.4597.36.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207490104.4597.36.camel@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-04-06 13:55:04, Soeren Sonnenburg wrote:
> On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
> > Hello; I seem to have discovered something with echo mem > /sys/power/state.
> > I recompile the kernel and had forgotten to compile fglrx, when
> > performing a suspend without fglrx I was confronted with the dreaded
> > blank screen and a reboot. then as a test I compiled fglrx and loaded,
> > and to my amazement suspend reacted properly again.
> 
> Yeah, but I it does not even work without X - console only!
> 
> s2ram -f -p used to work since at least 2.6.20 ... and is now not
> anymore in 2.6.25-*

Can you do git bisect?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
