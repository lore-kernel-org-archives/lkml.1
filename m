Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYGFOrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYGFOrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbYGFOrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:47:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2643 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756906AbYGFOra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:47:30 -0400
Date: Fri, 27 Jun 2008 21:14:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080627191458.GA10872@ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623160052.GA7616@ldl.fc.hp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> A driver for the HP iLO/iLO2 management processor, which allows userspace
> programs to query the management processor.  Programs can open a channel
> to the device (/dev/hpilo/dXccbN), and use this to send/receive queries.  

What kind of queries? Is there documentation somewhere?

If it can read temperature, it should hook itself into hwmon
framework. Can it? What can it do?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
