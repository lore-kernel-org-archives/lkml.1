Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZHNS7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZHNS7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZHNS7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:59:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38423 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZHNS7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:59:38 -0400
Date: Fri, 14 Aug 2009 20:58:52 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Jamie Lokier <jamie@shareable.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090814185852.GO13320@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <4A85AAC4.7050505@acm.org> <20090814184651.GA12021@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090814184651.GA12021@shareable.org>
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
X-Uptime: 20:57:36 up 9 days,  6:16,  5 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 07:46:51PM +0100, Jamie Lokier wrote:
> Zan Lynx wrote:
> > Or maybe its cheap and slow flash. In that case I think your only
> > hope is to make all the code as small as possible and/or find a
> > different flash filesystem that does not have to read so much of the
> > device to mount. Perhaps use a read-only compressed filesystem for
> > the system binaries and reflash it for software upgrades. Only init
> > and mount the writable flash for user-storable data well after
> > system boot has finished.
>
> Fwiw, logfs claims to mount quickly, but I haven't heard much about it
> in recent months and http://logfs.org/logfs/ implies it's not really
> stable yet. But maybe if you're working on a prototype that doesn't
> matter so much.

Is logfs ready for production in the meantime? Last time I checked it
was still more or less Jörn's pet project and ubifs seemed much more
mature.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
