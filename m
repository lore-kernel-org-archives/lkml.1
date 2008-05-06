Return-Path: <linux-kernel-owner+w=401wt.eu-S1765698AbYEFJ22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765698AbYEFJ22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765169AbYEFJTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:19:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:48034 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765229AbYEFJTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:19:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,443,1204531200"; 
   d="scan'208";a="380457602"
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
From: Shaohua Li <shaohua.li@intel.com>
To: Holger Macht <hmacht@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
In-Reply-To: <20080506091522.GA4378@homac>
References: <20080505202508.GA3690@homac>  <20080506091522.GA4378@homac>
Content-Type: text/plain
Date: Tue, 06 May 2008 17:23:31 +0800
Message-Id: <1210065811.12668.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-06 at 17:15 +0800, Holger Macht wrote:
> On Mo 05. Mai - 22:25:08, Holger Macht wrote:
> > If acpi_install_notify_handler() for a bay device fails, the bay
> driver is
> > superfluous. Most likely, another driver (like libata) is already
> caring
> > about this device anyway. Furthermore,
> > register_hotplug_dock_device(acpi_handle) from the dock driver must
> not be
> > called twice with the same handler. So clean up and exit.
> 
> The patch needs some more work. I'll send an updated one as soon as
> ready.
The bay driver is duplicated with libata, I thought we should delete it.
See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526

Thanks,
Shaohua

