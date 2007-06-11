Return-Path: <linux-kernel-owner+w=401wt.eu-S1763828AbXFKB6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763828AbXFKB6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 21:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbXFKB56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 21:57:58 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54615 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760143AbXFKB55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 21:57:57 -0400
X-Sasl-enc: ljU7/c7RTX50XBlRecy/PVaWwpw8TnskJuQ5HDuFby7Y 1181527076
Date: Sun, 10 Jun 2007 22:57:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Hughes <hughsient@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       Richard Purdie <rpurdie@openedhand.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
Subject: Re: [patch] Move led attributes out of device name and into sysfs attributes, was Re: LED devices
Message-ID: <20070611015749.GA24151@khazad-dum.debian.net>
References: <1180710270.3782.5.camel@localhost.localdomain> <1180712592.6390.139.camel@localhost.localdomain> <1180713579.12843.8.camel@localhost.localdomain> <1180715004.6390.169.camel@localhost.localdomain> <20070608185710.GB14372@kroah.com> <20070610101155.GA25070@elf.ucw.cz> <1181505736.5241.1.camel@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181505736.5241.1.camel@work>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard!

On Sun, 10 Jun 2007, Richard Hughes wrote:

> On Sun, 2007-06-10 at 12:11 +0200, Pavel Machek wrote:
> > Can we keep the original naming? spitz:disk is as unique as led02, and
> > it is _way_ easier to use.
> > Come on, I want to use the led subsystem from the scripts... 
> 
> I don't see a problem with spitz_disk, which is just as easy to use in
> scripts.

It is the old problem with mV in battery_level_mV.  How do you know for sure
what is the designator, and what is the unit (or in this case, color)?  You
could take the last _[^_]+, but what if there is no unit/color? etc.

There is a BIIIIG thread about it (or more than one, actually) in the
archives, and I don't recall a consensus being reached.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
