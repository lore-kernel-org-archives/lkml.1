Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbYCBUyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbYCBUyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYCBUyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:54:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42540 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbYCBUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:54:22 -0500
Date: Sun, 2 Mar 2008 12:54:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Mike@Keehan.net, linux-kernel@vger.kernel.org
Subject: Re: strange behavior on multimedia eject button for cdrom
Message-ID: <20080302125402.4af85abc@laptopd505.fenrus.org>
In-Reply-To: <47CB11FA.60008@t-online.de>
References: <47C15020.8040806@t-online.de>
	<47C7FECD.3040205@Keehan.net>
	<47CB11FA.60008@t-online.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Mar 2008 21:45:46 +0100
Harald Dunkel <harald.dunkel@t-online.de> wrote:

> Hi Mike,
> 
> Mike Keehan wrote:
> > Hi Harold.
> > 
> > Somewhere on the web I read that some of the M1330 media keys are 
> > directly connected to the drive, hence the lack of keycodes.
> > 
> > If you eject a disk while it is being played, then the Linux driver
> > will get a read failure.  What happens then may not be well
> > defined :)
> > 
> 
> Maybe there is some misunderstanding here: I am not playing music
> from the CD. It is idle. But if I press the CD eject button, then
> audio output (e.g. some mp3 file played from harddisk) gets
> corrupted, the network connection is dead, etc.
> 
> Ejecting the CD takes about 7 seconds. Durig this time Linux is
> dead! I haven't checked any SCHED_FIFO or SCHED_RR applications,
> but AFAIK this shouldn't happen.
> 
> If I run "eject cdrom" on the console instead, then there is no
> such problem.


try (temporarily) disable the hal storage polling thing.....
that could well avoid the entire issue.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
