Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYGMMyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYGMMyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 08:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYGMMyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 08:54:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1505 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752448AbYGMMyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 08:54:13 -0400
Date: Sun, 13 Jul 2008 14:54:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Luke -Jr <luke@dashjr.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: suspend/idle hanging
Message-ID: <20080713125403.GA15331@ucw.cz>
References: <200807112351.34997.luke@dashjr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807112351.34997.luke@dashjr.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-07-11 23:51:32, Luke -Jr wrote:
> I finally got Linux and BusyBox booting on my board, but I've encountered a 
> fairly odd problem... any task that sleeps just goes dead entirely, never 
> resuming. If I enable networking support, this seems to happen before init is 
> even spawned (in this case, inside cpu_idle() according to remote gdb).
> 
> I'm guessing interrupts aren't firing for some reason, but does anyone else 
> have any ideas? Maybe this is more obvious/common than I'm guessing.

Try irqpoll? nohz=off?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
