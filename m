Return-Path: <linux-kernel-owner+w=401wt.eu-S934786AbXGYSaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786AbXGYSaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765116AbXGYSaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:30:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3014 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194AbXGYSaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:30:06 -0400
Date: Wed, 25 Jul 2007 13:39:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: 2.6.22 - Suspend and Weird Load Averages
Message-ID: <20070725133919.GA9256@ucw.cz>
References: <469E1AFE.7010108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E1AFE.7010108@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> For the first time since 1997 I have a machine (Mac 
> Mini) running a stock kernel which I am 
> suspending/resuming for 2 days now without any problems. 
> Amongst the various hardware and kernel versions that 
> I've used so far this combination is the first to 
> suspend/resume without issues!
> 
> But one thing that annoys me a bit is that the load 
> averages spike up quite a bit after resume although it 
> doesn't feel like the machine is loaded  -
> 
> Before Resume -
> parag@parag-desktop:~$ uptime
> 09:35:14 up  5:18,  2 users,  load average: 0.08, 0.87, 
> 1.00
> After Resume -
> parag@parag-desktop:~$ uptime
> 09:36:37 up  5:18,  2 users,  load average: 12.53, 3.83, 
> 1.98
> parag@parag-desktop:~$
> 
> Is this a known problem? Worth fixing?

Known, and Rafael/Nigel have patches to fix that.

OTOH I'm not sure it is a problem -- lets just say that suspend is
hard work and therefore it raises load avg?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
