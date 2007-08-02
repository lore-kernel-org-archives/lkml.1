Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXHBP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXHBP4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXHBPz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:55:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1346 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755481AbXHBPz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:55:58 -0400
Date: Thu, 2 Aug 2007 15:55:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802155545.GA3974@ucw.cz>
References: <46B1988C.3090302@t-online.de> <20070802015248.45a40717.akpm@linux-foundation.org> <p731wemnre6.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p731wemnre6.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I didn't understand the arguments either, actually.
> 
> The issue is that you can actually kill hardware by setting this wrong.
> We've had such cases where trip point problems eventually lead
> to overheated laptops with hard disks dying etc. 

Actually, that was my machine. Omnibook xe3; BIOS provided trip points
*did* kill the disk. At least I was able to work around it with
writing to trip points.

Yes, ACPI mandates emergency shutdown when critical+delta point is
reached, *in hardware*. So this only endangers very broken machines,
and it also fixes lot of them.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
