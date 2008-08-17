Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYHQJdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYHQJdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 05:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYHQJdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 05:33:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53208 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYHQJdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 05:33:10 -0400
Date: Sun, 17 Aug 2008 11:33:09 +0200
From: Pavel Machek <pavel@suse.cz>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: PM_TRACE is no longer experimental
Message-ID: <20080817093309.GA8368@atrey.karlin.mff.cuni.cz>
References: <20080814151833.GA23300@elf.ucw.cz> <48A5B8C8.6040504@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A5B8C8.6040504@imap.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 14.08.2008 17:18 Pavel Machek wrote:
> > PM_TRACE is stable for quite long. I don't think it needs to depend on
> > experimental.
> 
> It might be stable, but its effect of trashing the RTC makes it unsuitable
> for non-experimental use. Therefore I'd prefer the dependency be kept.

Given that it is enabled in both 32-bit and 64-bit defconfig, I don't
think we can call it experimental.

Plus IIRC it needs command line option to thrash RTC.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
