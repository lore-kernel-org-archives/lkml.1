Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYGaSMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYGaSMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYGaSMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:12:40 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:52636 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbYGaSMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:12:38 -0400
Date: Thu, 31 Jul 2008 20:12:14 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731181214.GD8254@pengutronix.de>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080731135319.GA20212@cs181140183.pp.htv.fi> <20080731162007.285938e0@surf> <20080731153757.GB20212@cs181140183.pp.htv.fi> <20080731182616.4c20f0db@surf> <20080731164918.GE20212@cs181140183.pp.htv.fi> <4891F724.3030406@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4891F724.3030406@am.sony.com>
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
X-Uptime: 20:07:00 up 30 days,  6:50,  9 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 10.1.0.65
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 10:32:20AM -0700, Tim Bird wrote:
> > And for embedded systems with which applications is it 100% safe to
> > disable this option?
>
> Sony's digital cameras.

We have also several very small automation & measurement devices in the
field which run a very dedicated more or less single application which
can be carefully audited.

In the OSADL safety working group, people are discussing about Linux for
safety critical applications. If we want to achieve such scenarios,
stripped-down systems are an absolute must.

Although increasing processor power even in embedded applications lead
to more and more standard-line kernels plus normal userspace components
(i.e. glibc instead of uclibc), there are still applications where the
final product consists only of the kernel plus the app, whereas during
development time, the system has a full-blown configuration.

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

