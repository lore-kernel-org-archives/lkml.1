Return-Path: <linux-kernel-owner+w=401wt.eu-S1765199AbYEFJb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765199AbYEFJb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYEFJbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:31:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:37661 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbYEFJbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:31:08 -0400
Date: Tue, 6 May 2008 11:33:16 +0200
From: Holger Macht <hmacht@suse.de>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506093315.GD4378@homac>
Mail-Followup-To: Shaohua Li <shaohua.li@intel.com>,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210065811.12668.1.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di 06. Mai - 17:23:31, Shaohua Li wrote:
> On Tue, 2008-05-06 at 17:15 +0800, Holger Macht wrote:
> > On Mo 05. Mai - 22:25:08, Holger Macht wrote:
> > > If acpi_install_notify_handler() for a bay device fails, the bay
> > driver is
> > > superfluous. Most likely, another driver (like libata) is already
> > caring
> > > about this device anyway. Furthermore,
> > > register_hotplug_dock_device(acpi_handle) from the dock driver must
> > not be
> > > called twice with the same handler. So clean up and exit.
> > 
> > The patch needs some more work. I'll send an updated one as soon as
> > ready.
> The bay driver is duplicated with libata, I thought we should delete it.
> See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526

Yes, I know, but couldn't it be helpful on systems not using libata?

Regards,
	Holger

