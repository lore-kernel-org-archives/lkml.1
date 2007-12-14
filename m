Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXLNU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXLNU4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXLNU4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:56:03 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:48871 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051AbXLNU4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:56:00 -0500
Date: Fri, 14 Dec 2007 21:55:42 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Message-ID: <20071214205542.GO3851@pengutronix.de>
References: <20071213195617.GF21616@stusta.de> <20071214200318.GM3851@pengutronix.de> <8bd0f97a0712141221o3a65a5efo40c19ab12f7078c6@mail.gmail.com> <20071214202829.GN3851@pengutronix.de> <8bd0f97a0712141235h48c3062cl139e4c2883a815a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <8bd0f97a0712141235h48c3062cl139e4c2883a815a9@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 21:38:45 up 28 days, 23:30, 10 users,  load average: 0.18, 0.18, 0.16
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: Re: Working upstream toolchain for avr32?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 03:35:36PM -0500, Mike Frysinger wrote:
> > Upstream plus a well defined patch stack with well documented patches
> > would definitely be preferred here.

Well, tell me that it is wrong, but isn't it common community
methodology to have rebasable things like patch stacks or git trees
against mainline instead of disconnected vendor trees?

> as you've been told in the past, the things are documented. go read
> the ChangeLog.bfin file.

You didn't explain how for example your trunk [1] is related to mainline
[2].

> > Ah, that sounds pretty good! At the moment we still need three different
> > toolchains to build u-boot, the kernel
>
> maybe, if you're using different version of u-boot and the kernel.
> but that isnt a good idea anyways.

We use mainline linux and u-boot-v2, which is surely not what ADI
supplies officially to their random commercial customers. Nevertheless,
it is the way community technology works elsewhere.

> > and the icebear tools, which is not very satisfying.
>
> there's nothing we can do about this and you're complaining to the
> wrong people. icebear is a third party binary-only tool.

Hmm, the sources are here: http://www.section5.ch/dsp/icebear/bfloader-1.2.tgz

Do you have a good hint for a better low level debug tool? For all other
processors like ARM, PowerPC and ColdFire we use a BDI2000, but it seems
not to be available for blackfin.

> if you dont like the way the third party does things, complain to
> the third party. or dont buy their product.

Thanks for the constructive comments.

> we are upstream and we've given you blessed toolchains.

"Trust us, we are $BIG_VENDOR" is not the way these things are usually
done. Sorry, I don't buy this. Chip vendors just too often lose interest
in supporting their users once they have moved to the next generations
of chips or whatever.

Can you explain why bfin should not have gcc.gnu.org as it's upstream?

Robert

[1] http://blackfin.uclinux.org/gf/project/toolchain/scmsvn/?action=browse&path=%2Ftrunk%2F
[2] http://gcc.gnu.org/viewcvs/trunk/
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

