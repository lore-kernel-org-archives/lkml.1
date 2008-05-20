Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYETTMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYETTMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbYETTMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:12:23 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:40515 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbYETTMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:12:22 -0400
Date: Tue, 20 May 2008 21:11:59 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, lvcargnini@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25.4-rt2 compile errors on ARM due to cmpxchg() problems.
Message-ID: <20080520191159.GL13814@pengutronix.de>
References: <3efb10970805200721u6a837a2ap94ead54f7eb7bf89@mail.gmail.com> <Pine.LNX.4.58.0805201034130.1838@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805201034130.1838@gandalf.stny.rr.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 21:09:37 up 81 days, 11 min, 18 users,  load average: 0.04, 0.01,
	0.00
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 10.1.1.3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Tue, May 20, 2008 at 10:34:54AM -0400, Steven Rostedt wrote:
> No idea right off the bat. But I may be needing to set up a ARM
> crosscompiler. Unless Thomas would like to take a look into this.

If you need an ARM cross compiler, you can for example use ptxdist to
setup an OSELAS.Toolchain:

http://www.pengutronix.de/oselas/toolchain/index_en.html

The current well tested revisions are based on 4.1.2, but -trunk does
also contain (work-in-progress) top-of-tree versions.

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

