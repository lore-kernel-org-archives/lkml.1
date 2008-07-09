Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYGIPve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYGIPve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYGIPv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:51:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51229 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754323AbYGIPv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:51:26 -0400
Date: Wed, 9 Jul 2008 16:18:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: Martin Knoblauch <knobi@knobisoft.de>, Pavel Machek <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080709161843.149f9055@the-village.bc.nu>
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BBB04814@G1W1215.americas.hpqcorp.net>
References: <19533.95591.qm@web32604.mail.mud.yahoo.com>
	<CF70AA892F109448AEA269483B3A983903BBB04814@G1W1215.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hpdiags and hp-snmp-agents both use this driver to gather basic
> management processor info, stuff like MP NIC config and stats,
> serial number, etc (but no sensors).

That all sounds like stuff which should be in sys or proc. That would
also give the simple read/write interfaces people want and make it
scriptable without random HP tools that may cease to be available some
day in the future.

As to supporting old software, well HP decided not to submit the original
driver so HP committed to a non upstream API. Thats a hole HP dug and
despite the fact people are always warned about it have now fallen down.

Alan
