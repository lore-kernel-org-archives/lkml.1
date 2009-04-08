Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbZDHG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbZDHG5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZDHG44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:56:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42381 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbZDHG4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:56:55 -0400
Date: Wed, 8 Apr 2009 08:56:53 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Identifying Intel Atom Z500PT
Message-ID: <20090408065652.GV5367@pengutronix.de>
References: <20090407222144.GU5367@pengutronix.de> <alpine.LFD.2.00.0904080251540.21577@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904080251540.21577@localhost.localdomain>
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
X-Uptime: 08:55:31 up 48 days, 22:49, 18 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:56:04AM +0200, Thomas Gleixner wrote:
> > Does anyone have an idea how to properly identify an Atom Z500PT cpu?
> > The get_model_name() mechanics in arch/x86/kernel/cpu/common.c uses
> > cpuid() to find out about the brand id, which is "Genuine Intel(R) CPU"
> > with family 6 and model 28.
>
> AFAICT cpuid() is the way to get the model name. If it returns
> "Genuine Intel(R) CPU" then the kernel merily prints that info.
>
> Consult your board vendor / BIOS tinkerer^Wdeveloper

Ah, that comes from the BIOS, good to know. Do you know any document
that shows what's the intended string for a Z500PT? I searched the intel
site but didn't find anything useful.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
