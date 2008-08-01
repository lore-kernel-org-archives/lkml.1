Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYHAH2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYHAH2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYHAH23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:28:29 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:41342 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYHAH22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:28:28 -0400
Date: Fri, 1 Aug 2008 09:28:13 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Tim Bird <tim.bird@am.sony.com>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080801072813.GK8254@pengutronix.de>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080731135319.GA20212@cs181140183.pp.htv.fi> <20080731162007.285938e0@surf> <20080731153757.GB20212@cs181140183.pp.htv.fi> <20080731182616.4c20f0db@surf> <20080731164918.GE20212@cs181140183.pp.htv.fi> <4891F724.3030406@am.sony.com> <20080731181214.GD8254@pengutronix.de> <20080731193126.GB23516@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080731193126.GB23516@cs181140183.pp.htv.fi>
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
X-Uptime: 09:27:07 up 30 days, 20:10, 18 users,  load average: 0.02, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 10.1.0.65
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 10:31:26PM +0300, Adrian Bunk wrote:
> > In the OSADL safety working group, people are discussing about Linux
> > for safety critical applications. If we want to achieve such
> > scenarios, stripped-down systems are an absolute must.
> >...
>
> My first reaction is that as soon as you enable CONFIG_EMBEDDED you
> can easily enter codepaths noone else has used for a while and that
> got unnoticed broken.

That may be no problem; if we ever come to a safety kernel, it will have
to be audited and carefully tested anyway.

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

