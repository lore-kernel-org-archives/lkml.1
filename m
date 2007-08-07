Return-Path: <linux-kernel-owner+w=401wt.eu-S1764219AbXHGNEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764219AbXHGNEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbXHGNEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:04:44 -0400
Received: from mail.suse.de ([195.135.220.2]:35433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbXHGNEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:04:42 -0400
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tejun Heo <htejun@gmail.com>, Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20070807125104.GC30661@khazad-dum.debian.net>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
	 <1186411815.4355.7.camel@nx6310>
	 <20070806150159.GC31615@khazad-dum.debian.net>
	 <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com>
	 <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com>
	 <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com>
	 <20070807125104.GC30661@khazad-dum.debian.net>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 07 Aug 2007 15:04:39 +0200
Message-Id: <1186491879.8780.51.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 09:51 -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 07 Aug 2007, Tejun Heo wrote:
> > Henrique de Moraes Holschuh wrote:
> > > On Tue, 07 Aug 2007, Tejun Heo wrote:
> > >> Michael Sedkowski wrote:
---snip---
> > > Any chances of changing things
> > > so that we inspect/snoop all tasks sent to the device, and filter them
> > > out, or react to them accordingly?
> > 
> > No, we can't unless we snoop ACPI method execution and detect accesses
> > to IO ports or iomem regions.  It's not going through any driver.  This
> > is a gross mess.
> 
> I don't mean fixing the stuff clowns like Toshiba did.  The correct fix for
> that is to blacklist the hell out of that crap and patch their DSDT into
> something remotely sane.
> 
> I do mean snooping the ACPI methods that *return* a taskset to send to the
> driver, and we send that taskset ourselves in libata and libpata(?).

I haven't read the whole thread in every detail, but this sounds like a
very intrusive, overdosed workaround.

Are the DSDT/SSDTs already lying around somewhere (collecting them in a
bug assigned to ACPI component should be a good idea)?
Could someone give me a pointer where this happens (best in code and
DSDT).

Thanks,

   Thomas

