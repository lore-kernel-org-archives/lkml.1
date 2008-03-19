Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbYCSX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbYCSX2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934489AbYCSWB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:01:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34480 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934482AbYCSWBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:01:24 -0400
Date: Tue, 18 Mar 2008 17:55:08 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 3/3] PM: New suspend and hibernation callbacks for
	PCI bus type
Message-ID: <20080319005508.GD8298@kroah.com>
References: <200803170020.55473.rjw@sisk.pl> <200803170025.16149.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803170025.16149.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 12:25:15AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Implement new suspend and hibernation callbacks for the PCI busi type.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-driver.c |  497 ++++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/pci.h      |    2 
>  2 files changed, 453 insertions(+), 46 deletions(-)

Hm, that's a lot of code added.  What additional functionality did we
just get?

Are we going to have to create a noirq version for every driver and bus
type now?

thanks,

greg k-h
