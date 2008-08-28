Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYH1U2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYH1U2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYH1U1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:27:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40481 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYH1U1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:27:46 -0400
Date: Thu, 28 Aug 2008 10:04:27 +0200
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       teheo@novell.com, stefanr@s5r6.in-berlin.de, Martin.Leisner@xerox.com
Subject: Re: autosuspend for SCSI devices
Message-ID: <20080828080427.GD15474@elf.ucw.cz>
References: <20080822105626.GA9475@elf.ucw.cz> <200808251055.45582.oneukum@suse.de> <20080826094355.GA30062@elf.ucw.cz> <200808261301.45167.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261301.45167.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-26 13:01:43, Oliver Neukum wrote:
> Am Dienstag 26 August 2008 11:43:55 schrieb Pavel Machek:
> > > firstly, it doesn't consider error handling before suspending.
> > 
> > What problems do you see with error handling? This patch does not
> > touch the error handling, and I do not think it needs to touch it.
> 
> You'd make scsi driver writers' life easier if you made sure no autosuspends
> happen while they recover from errors. After all, you have no idea which
> commands will get through while the bus is in disarray.

Well, they have to handle other commands while bus has problems,
anyway, right? So I'm not creating any _new_ problems for them. 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
