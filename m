Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXKIEfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXKIEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 23:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXKIEfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 23:35:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbXKIEfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 23:35:36 -0500
Date: Thu, 8 Nov 2007 20:34:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: rjw@sisk.pl, hannes-kernel@saeurebad.de, listen@selfservix.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
Message-Id: <20071108203451.1b7f28c0.akpm@linux-foundation.org>
In-Reply-To: <47333ACB.6070408@suse.de>
References: <1193652664.22149.4.camel@localhost>
	<200711050118.34610.rjw@sisk.pl>
	<20071108155344.GA12231@cataract>
	<200711081717.00421.rjw@sisk.pl>
	<47333ACB.6070408@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A> On Thu, 08 Nov 2007 19:35:23 +0300 Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
> [remove_cycle_at_battery_removal.patch  text/x-patch (1.7KB)]
> ACPI: Battery: remove cycle from battery removal.
> 
> From: Alexey Starikovskiy <astarikovskiy@suse.de>
> 
> get_property() should not call battery_update() on absent battery to
> avoid cycle and oops.
> 
> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

A patch similar to this one but with an identical changelog was merged into
Len's tree on November 2.

If it had been promptly merged into mainline then quite a lot of people's
time would not have been wasted.

