Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYAUOUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYAUOUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYAUOUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:20:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:17290 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYAUOUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:20:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,227,1199692800"; 
   d="scan'208";a="254546739"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 9/10] introduce intel_menlow platform specific driver
Date: Mon, 21 Jan 2008 19:49:55 +0530
Message-ID: <05B550FD4BD2014E841D83547B6260080281AE80@bgsmsx411.gar.corp.intel.com>
In-Reply-To: <20080121095331.GA5333@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 9/10] introduce intel_menlow platform specific driver
Thread-Index: AchcE4C4/PIBJ7+IT+28phBillEmtAAAq2iQ
References: <1200556278.2935.118.camel@acpi-sony.sh.intel.com> <20080121095331.GA5333@infradead.org>
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
Cc: <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Jan 2008 14:20:00.0848 (UTC) FILETIME=[B53A4D00:01C85C38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, January 21, 2008 3:24 PM
> To: Zhang, Rui
> Cc: lenb@kernel.org; linux-acpi@vger.kernel.org; linux-pm@lists.linux-
> foundation.org; linux-kernel@vger.kernel.org; Thomas, Sujith
> Subject: Re: [PATCH 9/10] introduce intel_menlow platform specific
driver
> 
> On Thu, Jan 17, 2008 at 03:51:17PM +0800, Zhang Rui wrote:
> > From: Thomas Sujith <sujith.thomas@intel.com>
> >
> > Intel menlow platform specific driver for thermal management.
> >
> > Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/misc/Kconfig        |   10
> >  drivers/misc/Makefile       |    1
> >  drivers/misc/intel_menlow.c |  527
> ++++++++++++++++++++++++++++++++++++++++++++
> 
> Why is this in drivers/misc?  I don't have a thermal.h in mainline,
but
> if this is a new subsystem your adding care to create a directory
under
> drivers/ for it?
This patch series adds a new "thermal" subsystem and is rightly placed
under drivers/thermal/ . intel_menlow.c isn't fully a thermal driver. It
does all the platform specific stuff (thermal is one of them). It's not
fitting under any of the subsystems hence moved to drivers/misc
> 
> > +/*
> > +*  intel_menlow.c - Intel menlow Driver for thermal management
> extension
> > +*
> > +*  Copyright (C) 2008 Intel Corp
> > +*  Copyright (C) 2008 Sujith Thomas <sujith.thomas@intel.com>
> > +*  Copyright (C) 2008 Zhang Rui <rui.zhang@intel.com>
> 
> Please add a whitespace before the * so they line up.
Will take care of this.
> 
> > +MODULE_AUTHOR("Thomas Sujith");
> > +MODULE_AUTHOR("Zhang Rui");
> 
> I've never seen a driver with two MODULE_AUTHOR statements before.
Does
> this actually work?  What does modinfo -F author say for your module?
There is nothing wrong in giving 2 MODULE_AUTHORS. Both will be
displayed in the command modinfo -F author.

:-Sujith

