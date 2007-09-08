Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbXIHQvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbXIHQvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXIHQuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:50:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35087 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXIHQuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:50:50 -0400
Date: Sat, 8 Sep 2007 09:48:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-Id: <20070908094852.3a6fd3f0.randy.dunlap@oracle.com>
In-Reply-To: <46E2D17E.9050805@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com>
	<20070907083522.3191a4ba.randy.dunlap@oracle.com>
	<20070907155903.GR16806@vanheusden.com>
	<46E17A81.7020304@s5r6.in-berlin.de>
	<20070907230529.GX16806@vanheusden.com>
	<46E249CB.5070505@s5r6.in-berlin.de>
	<46E2CE73.3000207@oracle.com>
	<46E2D17E.9050805@s5r6.in-berlin.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Sep 2007 18:44:46 +0200 Stefan Richter wrote:

> Randy Dunlap wrote:
> > Stefan Richter wrote:
> >> I am not a friend of 'select', but maybe the following actually helps.
> ...
> > The problem with 'select' here is that it will enable BLK_DEV_SD,
> > but if SCSI is not enabled, it will not become enabled -- i.e.,
> > select does not follow the dependency chain.  So usually the
> > kernel will not build unless SCSI is enabled by the user.
> ...
> >> config ATA_SD
> >>     tristate "SATA/PATA HDD support (via SCSI disk support)"
> >>     depends on ATA
> >>     select BLK_DEV_SD
> >>     help
> >>       'SCSI disk support' is required to access SATA HDDs.  It is
> ...
> 
> I checked the dependencies.  ATA depends on SCSI (actually, selects
> SCSI), so all is well.  Otherwise I would have added more dependencies
> to ATA_SD.

Ah, that's good, then.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
