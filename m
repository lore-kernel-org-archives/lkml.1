Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYKJHzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYKJHzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYKJHzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:55:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33719 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbYKJHza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:55:30 -0500
Date: Mon, 10 Nov 2008 08:55:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081110075529.GD707@atrey.karlin.mff.cuni.cz>
References: <20081109140726.GB1786@ucw.cz> <20081110075216.GD2093@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110075216.GD2093@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Pavel Machek <pavel@suse.cz> wrote:
> 
> > ...at least on 2.6.27 and 2.6.28-rc3. Resume gets to 
> > acpi_hibernation_leave, then SLAB corruption is detected and machine 
> > ends in series of oops.
> > 
> > Any ideas how to debug that?
> 
> do you get any serial log or USB key output, so that it's debuggable 
> directly?

Well, I can transcribe the BUG() from a picture, I guess, but it does
not seem to contain much useful info: SLAB corruption was detected and
backtrace is not quite important at that point...

Serial console is probably possible, but would take few days to setup.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
