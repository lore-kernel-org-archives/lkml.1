Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYAXVkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYAXVkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbYAXVjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:39:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:51959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYAXVjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:39:53 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/10] introduce intel_menlow platform specific driver
Date: Thu, 24 Jan 2008 16:39:33 -0500
User-Agent: KMail/1.9.5
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       sujith.thomas@intel.com
References: <1200556278.2935.118.camel@acpi-sony.sh.intel.com> <20080121095331.GA5333@infradead.org>
In-Reply-To: <20080121095331.GA5333@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241639.33898.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 04:53, Christoph Hellwig wrote:
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
> >  drivers/misc/intel_menlow.c |  527 ++++++++++++++++++++++++++++++++++++++++++++
> 
> Why is this in drivers/misc?  I don't have a thermal.h in mainline, but
> if this is a new subsystem your adding care to create a directory under
> drivers/ for it?

Hi Christoph,

I'm sure it was me who suggested putting intel_menlo.c under drivers/misc.

A while back I refused to let any new platform specific drivers under
drivers/acpi, and asked that the ones here already move out.
This is because they happne to use ACPI, but are not actually
part of the ACPI sub-system (any more than ATA is).
Also, I wanted the maintainer roles to be clear -- these
drivers have primary maintainers other than me, and those
guys are in the heroic, but tragic, business of writing
platform-specific drivers for systems with no documentation or vendor support.

drivers/misc/asus-laptop.c
drivers/misc/fujitsu-laptop.c
drivers/misc/msi-laptop.c
drivers/misc/sony-laptop.c
drivers/misc/thinkpad_acpi.c
drivers/misc/sony-laptop.c

intel_menlo.c fits in with this group, the only difference is that
its primary maintainers actually have documentation:-)

is there a better place than drivers/misc for this group?

thanks,
-Len

