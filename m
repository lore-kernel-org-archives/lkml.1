Return-Path: <linux-kernel-owner+w=401wt.eu-S932355AbXLNU3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbXLNU3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764538AbXLNU2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:28:45 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:36734 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763884AbXLNU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:28:44 -0500
Date: Fri, 14 Dec 2007 21:28:29 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Adrian Bunk <bunk@kernel.org>,
       hskinnemoen@atmel.com, linux-kernel@vger.kernel.org
Message-ID: <20071214202829.GN3851@pengutronix.de>
References: <20071213195617.GF21616@stusta.de> <20071214200318.GM3851@pengutronix.de> <8bd0f97a0712141221o3a65a5efo40c19ab12f7078c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <8bd0f97a0712141221o3a65a5efo40c19ab12f7078c6@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 21:22:44 up 28 days, 23:14, 10 users,  load average: 0.07, 0.13, 0.15
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: Re: Working upstream toolchain for avr32?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 03:21:45PM -0500, Mike Frysinger wrote:
> > Is an upstream toolchain available which is able to build blackfin?
>
> binutils -- yes
> uClibc -- yes (for FLAT)
> gcc -- yes and no
>
> we have some pieces in gcc, but if you want an
> up-to-date-tested-known-working combination, you can fetch
> sources/binaries from:
> http://blackfin.uclinux.org/gf/project/toolchain/frs

Upstream plus a well defined patch stack with well documented patches
would definitely be preferred here.

> we're working now to make sure that when gcc-4.3 is branched/released,
> we're part of it

Ah, that sounds pretty good! At the moment we still need three different
toolchains to build u-boot, the kernel and the icebear tools, which is
not very satisfying. An upstream-blessed toolchain would probably be
progress.

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

