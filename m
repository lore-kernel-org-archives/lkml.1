Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbYEULDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbYEULDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbYEULDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:03:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:60164 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbYEULDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:03:38 -0400
Date: Wed, 21 May 2008 13:06:17 +0200
From: Holger Macht <hmacht@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristen.c.accardi@intel.com, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080521110616.GB9330@homac>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kristen.c.accardi@intel.com, Len Brown <lenb@kernel.org>
References: <20080521104547.GA8097@homac> <20080521105944.GA30728@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521105944.GA30728@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21. May - 11:59:44, Matthew Garrett wrote:
> On Wed, May 21, 2008 at 12:45:47PM +0200, Holger Macht wrote:
> > If acpi_install_notify_handler() for a bay device fails, the bay driver is
> > superfluous. Most likely, another driver (like libata) is already caring
> > about this device anyway. Furthermore,
> > register_hotplug_dock_device(acpi_handle) from the dock driver must not be
> > called twice with the same handler. This would result in an endless loop
> > consuming 100% of CPU. So clean up and exit.
> 
> The bay driver still provides the only mechanism for calling the eject 
> methods.

Yes, I'll send a patch on top of the libata hotplug fixes as soon as it's
in for that. But this patch has nothing to do with this. Without it, you
get an unusable system.

Regards,
	Holger

