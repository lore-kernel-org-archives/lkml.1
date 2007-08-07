Return-Path: <linux-kernel-owner+w=401wt.eu-S933560AbXHGNRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbXHGNRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759814AbXHGNQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:16:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59589 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758319AbXHGNQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:16:56 -0400
X-Sasl-enc: Qb6lAJ9zx9dD3xrnT53QL6mYuMCax+5GQnIaWL/zhnjk 1186492614
Date: Tue, 7 Aug 2007 10:16:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
Message-ID: <20070807131651.GE30661@khazad-dum.debian.net>
References: <1186411815.4355.7.camel@nx6310> <20070806150159.GC31615@khazad-dum.debian.net> <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com> <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com> <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com> <20070807125104.GC30661@khazad-dum.debian.net> <46B86F21.4030805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B86F21.4030805@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Tejun Heo wrote:
> Henrique de Moraes Holschuh wrote:
> >> approximately translates into "if you have too many boatmen on a ship,
> >> it goes to mountain".  We also have a bunch of Toshiba laptops which
> > 
> > Yeah, that's a problem.  But we can avoid it if we start snooping what ACPI
> > is asking us to deliver to the disks, which IMO is an extremely good idea
> > anyway.
> 
> If it were done that way (by asking OS driver to deliver commands TFs),
> I wouldn't have any problem at all.  The spin down command is issued
> from deep down in the acpi power off method - entering S5 directly
> issues ATA commands bypassing the whole OS except for the ACPI
> interpreter.  It's just like the toshiba suspend crap and there's no
> standard way to tell whether the acpi power off method is gonna do it or
> not.  We'll just have to blacklist it.

Urk. I see.

I'd also suggest adding a FAIL to the Linux firmware toolkit to any DSDT
doing this.  Who should we prod to add that check?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
