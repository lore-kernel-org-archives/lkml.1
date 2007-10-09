Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXJIOMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXJIOMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXJIOMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:12:23 -0400
Received: from nn7.de ([85.214.94.156]:40922 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXJIOMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:12:22 -0400
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, nickpiggin@yahoo.com.au
In-Reply-To: <470B7D7E.5070901@wpkg.org>
References: <470B7D7E.5070901@wpkg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Oct 2007 14:12:12 +0000
Message-Id: <1191939132.4377.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-09 at 15:09 +0200, Tomasz Chmielewski wrote:
> Soeren Sonnenburg wrote:
> 
> >> Fixing recursive fault but reboot is needed!
> > 
> > Hmmhh, so now I rebooted and again tried to
> > 
> > $ make
> > 
> > the new kernel which again triggered this(?) BUG:
> 
> I had a similar issue with 2.6.22.9, but as I had a proprietary nvidia 
> module loaded, I didn't report it. X was not enabled, though.
> 
> At this moment, the machine was spawning quite a bit of bash / awk etc. 
> processes with large variables (50 MB or so), and used memory and CPU a lot.
> 
> Normally, it's my desktop machine, and it's rarely on for more than ~12 
> hours, but this time, I left it on for a couple of days.
> 
> After this happened, these bash / awk processes died. After I restarted 
> the script again, I lost ssh access to the machine, and I saw no more 

I am afraid you are seeing some kind of hardware failure/bad driver
behavior, just the symptom is the same.

I am saying this as I have an uptime of 22 days with that very same
machine now. And all I changed was unloading the asus p7131 dvb-t driver
(saa71xx).

Soeren
