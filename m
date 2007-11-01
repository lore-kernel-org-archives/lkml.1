Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXKASE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXKASE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbXKASET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:04:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55789 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbXKASES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:04:18 -0400
Date: Thu, 1 Nov 2007 19:05:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Issue building kernel driver
Message-ID: <20071101180553.GB3312@uranus.ravnborg.org>
References: <1193938746.7555.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193938746.7555.7.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 12:39:06PM -0500, Chris Holvenstot wrote:
> 
> Although it may not be popular with the crowd here, I do have a valid
> reason to run Windows - and I accomidate this using the VirtualBox
> product.  
> 
> Since I try to be slightly useful and build as many of the "test" kernel
> images I can I end up rebuilding the VirtualBox kernel driver (open
> source) on an almost daily basis.

We had an report about the vbox package a few days ago.
I looked at it and the vbox code is so ugly that it was not fun at all.
They play some very strange games in their include hell and that is
obviously doomed to do so.
You are unfortunately as a user hit by this and the only
recommendation I have is to report it back to the vbox people.
Fixing vbox may be trivial if you dive into their include hell
but I do think you are better off talking to the vbox people here.

They may say that "the kernel changed - fix the kernel" but we have the
~1800 modules building in the kernel so they need to fix their end of stuff. 

Good luck,

	Sam
