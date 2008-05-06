Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbYEFJNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbYEFJNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbYEFJNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:13:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:34197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYEFJNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:13:13 -0400
Date: Tue, 6 May 2008 11:15:22 +0200
From: Holger Macht <hmacht@suse.de>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506091522.GA4378@homac>
Mail-Followup-To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
References: <20080505202508.GA3690@homac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505202508.GA3690@homac>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo 05. Mai - 22:25:08, Holger Macht wrote:
> If acpi_install_notify_handler() for a bay device fails, the bay driver is
> superfluous. Most likely, another driver (like libata) is already caring
> about this device anyway. Furthermore,
> register_hotplug_dock_device(acpi_handle) from the dock driver must not be
> called twice with the same handler. So clean up and exit.

The patch needs some more work. I'll send an updated one as soon as ready.

Regards,
	Holger
