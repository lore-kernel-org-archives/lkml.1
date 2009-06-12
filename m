Return-Path: <linux-kernel-owner+w=401wt.eu-S1764179AbZFLKSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764179AbZFLKSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbZFLKSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:18:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43888 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbZFLKSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:18:13 -0400
Date: Fri, 12 Jun 2009 12:18:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH] lis3: add click function
Message-ID: <20090612101805.GC18682@elf.ucw.cz>
References: <1244750146-31215-1-git-send-email-daniel@caiaq.de> <20090611210755.GC27376@elf.ucw.cz> <20090612101300.GC29236@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612101300.GC29236@buzzloop.caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-12 12:13:00, Daniel Mack wrote:
> On Thu, Jun 11, 2009 at 11:07:55PM +0200, Pavel Machek wrote:
> > > The LIS3 accelerometer chip has a 'click' feature which can be used to
> > > detect sudden motion on any of the three axis. Configuration data is
> > > passed via spi platform_data and no action is taken if that's not
> > > specified, so it won't harm any existing platform.
> > > 
> > > To make the configuration effective, the IRQ lines need to be set up
> > > appropriately. This patch also adds a way to do that from board support
> > > code.
> > > 
> > > The DD_* definitions were removed because I couldn't find any reference
> > > of them in the datasheet and the overlapped with the CLICK_ register
> > > space.
> > > 
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > Cc: Pavel Machek <pavel@ucw.cz>
> > > Cc: Eric Piel <eric.piel@tremplin-utc.net>
> > 
> > Well, patch looks mostly okay, but it would be nice to separate
> > cleanups onto separate patch... 
> 
> Yes, I've seen that, but considered the two minor things too small to
> deserve a seperate patch. Do you want me resend?

Well, I guess it would be best if you reverted those cleanups and
resent. You can get my acked-by: on that; cc akpm.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
