Return-Path: <linux-kernel-owner+w=401wt.eu-S1763082AbZDHSZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763082AbZDHSZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbZDHSZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:25:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37605 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZDHSZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:25:03 -0400
Date: Wed, 8 Apr 2009 20:24:57 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: Re: Identifying Intel Atom Z500PT
Message-ID: <20090408182457.GX5367@pengutronix.de>
References: <20090407222144.GU5367@pengutronix.de> <49DCE2E3.7050700@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <49DCE2E3.7050700@googlemail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 20:22:59 up 49 days, 10:16, 16 users,  load average: 0.03, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wed, Apr 08, 2009 at 07:46:11PM +0200, Michael Riepe wrote:
> Robert Schwebel wrote:
> > Does anyone have an idea how to properly identify an Atom Z500PT cpu?
> > The get_model_name() mechanics in arch/x86/kernel/cpu/common.c uses
> > cpuid() to find out about the brand id, which is "Genuine Intel(R) CPU"
> > with family 6 and model 28.
>
> Family 6, model 28, stepping 2 seems to be common to all current Atoms
> -- my 330 reports the same. There are some flags, however, that
> currently only appear in the Z series, e.g. vmx is not available on the
> 230/330/N270. To differentiate between the latter, you could look for
> 64-bit support (which is missing in the N270) and the number of cores.
> Besides that, the 230/330 models lack the speedstep feature.
>
> I don't know if there's a way to distinguish a -P model from a -PT
> model. But from a software point of view, they should be identical anyway.

Yup, should not matter from the software side.

> > Below is the output of /proc/cpuinfo on that box:
> >
> > root@phyCORE:~ cat /proc/cpuinfo | grep model | head -n 2
> > model           : 28
> > model name      : Genuine Intel(R) CPU        @ 1.10GHz
>
> Strange - the 330 reports:
>
> model name      : Intel(R) Atom(TM) CPU  330   @ 1.60GHz
>
> (running 2.6.29).

Looks like the model name string comes from the BIOS, I suppose I'll
have to talk to the BIOS guys in order to resolve that issue.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
