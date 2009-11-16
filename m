Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZKPOYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZKPOYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZKPOYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:24:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43494 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZKPOYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:24:18 -0500
Date: Mon, 16 Nov 2009 15:22:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: -rc6: something (probably active usb bluetooth) blocks suspend
Message-ID: <20091116142236.GA1796@ucw.cz>
References: <20091116112254.GB12315@elf.ucw.cz> <200911161443.20704.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911161443.20704.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-16 14:43:20, Oliver Neukum wrote:
> Am Montag, 16. November 2009 12:22:54 schrieb Pavel Machek:
> > Linux amd 2.6.32-rc6-00498-g05b553a-dirty #89 SMP Fri Nov 13 10:43:31
> > CET 2009 i686 GNU/Linux
> > 
> > ...and yes, it is a regression. Hw is thinkpad x60.
> > 
> > Tried to suspend, machine came right back, used radio kill switch, and
> > it suspended ok. Relevant messages seem to be:
> 
> I forgot to ask. Is this repeatable? The code is build on the

It happened once...  

> assumption
> that workqueues are frozen as the system calls suspend for system
> sleep. If that assumption is wrong, a race can lead to this failure.
> Is it wrong?

There are two kinds of workqueues -- AFAICT -- kind one is frozen,
kind two is not.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
