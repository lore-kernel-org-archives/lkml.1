Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbYBKLZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbYBKLZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYBKLZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:25:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYBKLZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:25:26 -0500
Date: Mon, 11 Feb 2008 06:25:15 -0500
From: Alan Cox <alan@redhat.com>
To: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@redhat.com, jeff@garzik.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Forcing PIO0 mode on reset must not freeze system
Message-ID: <20080211112515.GB28762@devserv.devel.redhat.com>
References: <20080210195556.GA5261@homac> <47AFB4DB.1000204@gmail.com> <20080211100446.GA4646@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211100446.GA4646@homac.suse.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:04:46AM +0100, Holger Macht wrote:
> Wouldn't the proper fix be to call ata_acpi_handle_hotplug _somewhere_?
> (which is currently called nowhere AFAICS)

I think so. The T61 at least generated ACPI dock and undock messages for
IDE master/slaves and we can use those.

