Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYJUANR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYJUANR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYJUANF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:13:05 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3865 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYJUANE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:13:04 -0400
Subject: Re: [PATCH 1/3] Add file patterns to MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
In-Reply-To: <20081020234553.GA13115@isilmar.linta.de>
References: <1224541704-30357-1-git-send-email-joe@perches.com>
	 <1224541704-30357-2-git-send-email-joe@perches.com>
	 <20081020225058.GA7184@isilmar.linta.de>
	 <1224543747.12101.66.camel@localhost>
	 <20081020234553.GA13115@isilmar.linta.de>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 17:12:58 -0700
Message-Id: <1224547979.12101.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 01:45 +0200, Dominik Brodowski wrote:
> On Mon, Oct 20, 2008 at 04:02:26PM -0700, Joe Perches wrote:
> > If you could send a more correct pattern,
> > it's easy to change.

Would you keep any PCMCIA pattern?

Perhaps:
F:	Documentation/pcmcia/
F:	include/pcmcia/
F:	drivers/pcmcia/cs*
F:	drivers/pcmcia/pcmcia*
F:	drivers/pcmcia/rsrc*

This should cover the core utilities and leave 
drivers that use pcmcia services out.

> Well, there are mostly four areas, which, in my opinion,
> should be solved like this:

> sound/pcmcia/		should be under		SOUND
> drivers/net/pcmcia/	should be under		NETWORK DEVICE DRIVERS
> drivers/scsi/pcmcia/	should be under		SCSI SUBSYSTEM
> drivers/char/pcmcia/cm4000_cs.c			OMNIKEY CARDMAN 4000 DRIVER
> drivers/char/pcmcia/cm4040_cs.c			OMNIKEY CARDMAN 4040 DRIVER

File patterns for these sections are setup as you suggested.

> and finally
> drivers/char/pcmcia/ipwireess/*			IPWIRELESS DRIVER

I didn't have a pattern for that section, thanks.

Also, file patterns are not exclusive.
A pattern may exist in more than 1 section.
A pattern with a trailing / includes all subdirectories.

cheers, Joe

