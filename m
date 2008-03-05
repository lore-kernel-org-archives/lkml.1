Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbYCEJh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbYCEJh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 04:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbYCEJgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 04:36:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33884 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbYCEJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:36:13 -0500
Date: Wed, 5 Mar 2008 10:36:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Message-ID: <20080305093610.GA700@atrey.karlin.mff.cuni.cz>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> (If I try to suspend to disk, I get a rather nasty oops; goes away
> with mem=3G. Related?)

The nasty oops is in swsusp_save+0x298 . 

rdx=0xffff810000001008 
rdi=0xffff81000c001008
rdi=0x0000000131613000

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
