Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbXENQUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbXENQUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXENQUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:20:35 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:40049 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751722AbXENQUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:20:34 -0400
Date: Mon, 14 May 2007 18:20:26 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: Thomas Gleixner <tglx@linutronix.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21: pmtmr losing time
Message-ID: <20070514162026.GA9407@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070430125200.GA5379@sommrey.de> <1177950216.5791.241.camel@localhost.localdomain> <20070430163944.GA29206@sommrey.de> <1177969115.5791.244.camel@localhost.localdomain> <20070501073624.GA6835@sommrey.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501073624.GA6835@sommrey.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:36:24AM +0200, Joerg Sommrey wrote:
> On Mon, Apr 30, 2007 at 11:38:34PM +0200, Thomas Gleixner wrote:
> > On Mon, 2007-04-30 at 18:39 +0200, Joerg Sommrey wrote:
> > > Here it is.  Maybe this problem is related to the usage of the
> > > "experimental" amd76x_pm module?
> > 
> > Can you please verify what happens w/o that module ?
> > 
> After rebooting the problem vanished for now.  It first appeared after
> an uptime of about 3 days.  I'll wait a few days.  If it shows
> again, then I'll check without amd76x_pm.

It really looks like amd76x_pm is causing the time loss.  Sadly, I have
no idea how to avoid this.  What happens when the pm-timer wraps around
while the processors are in C3 sleep state?  How is this wrap detected
at all?  Is there anything I could put into amd76x_pm?  It's no problem
detecting a timer wrap there.

-jo

-- 
-rw-r--r-- 1 jo users 62 2007-05-13 21:55 /home/jo/.signature
