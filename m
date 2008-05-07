Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbYEGBYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbYEGBYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYEGBXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:23:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:19052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYEGBXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:23:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="561638508"
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
From: Shaohua Li <shaohua.li@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Holger Macht <hmacht@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
In-Reply-To: <20080507011354.GA8163@khazad-dum.debian.net>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac>
	 <1210065811.12668.1.camel@sli10-desk.sh.intel.com>
	 <20080506151846.GA22828@khazad-dum.debian.net>
	 <1210122279.27316.2.camel@sli10-desk.sh.intel.com>
	 <20080507011354.GA8163@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 07 May 2008 09:27:38 +0800
Message-Id: <1210123658.30944.6.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-06 at 22:13 -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 07 May 2008, Shaohua Li wrote:
> > On Tue, 2008-05-06 at 12:18 -0300, Henrique de Moraes Holschuh wrote:
> > > On Tue, 06 May 2008, Shaohua Li wrote:
> > > > The bay driver is duplicated with libata, I thought we should delete it.
> > > > See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526
> > > 
> > > The bay driver is currently useless, BUT it should handle a lot of stuff
> > > libata won't, such as bay batteries, bay floppies, and anything else in
> > > a bay that is not a hard disk.
> > > 
> > > The fact that the driver currently looks only after disks is just a bug.
> > > It should, in fact, bind to any ejectable device not already handled by
> > > a different driver.
> > Isn't this the job of acpi dock driver?
> 
> No, but I actually fail to see why do we even care about the difference
> from a dock to a bay.  Dock *could* be made to handle both.
It appears some systems haven't a dock but a bay. In a thinkpad, you
could hotplug cdrom/battery/harddisk in the slot of cdrom, but it's not
a dock. libata should handle it well (but it doesn't handle _EJ0
currently, I have a patch in above bugzilla).

But you are right, acpi dock driver should be extended to support bay.
I'll give it a try.

Thanks,
Shaohua

