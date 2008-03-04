Return-Path: <linux-kernel-owner+w=401wt.eu-S1764166AbYCDPHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764166AbYCDPHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbYCDPHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:07:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1894 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756863AbYCDPHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:07:01 -0500
Date: Tue, 4 Mar 2008 16:06:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Diego Woitasen <diego@woitasen.com.ar>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: High resolution timer/dynticks bug
Message-ID: <20080304150651.GB5310@ucw.cz>
References: <20080303010753.GB3512@motherbox.xtech.com.ar> <20080304110900.GA23227@elf.ucw.cz> <Pine.LNX.4.64.0803041213260.18589@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803041213260.18589@twin.jikos.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-04 12:14:38, Jiri Kosina wrote:
> On Tue, 4 Mar 2008, Pavel Machek wrote:
> 
> > Just turn off NMI watchdog? Pulling the power cable causes the SMM trap, 
> > which takes _long_ to execute, potentially tickling NMI watchdog?
> 
> By _long_ you mean leaving the system for 5 seconds with irqs disabled? 

Well, I've seen >500msec. 5sec is a bit much, but... BIOS writers are
crazy, right?

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
