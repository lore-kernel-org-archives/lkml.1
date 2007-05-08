Return-Path: <linux-kernel-owner+w=401wt.eu-S967564AbXEHB0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967564AbXEHB0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 21:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966602AbXEHB0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 21:26:33 -0400
Received: from ns1.suse.de ([195.135.220.2]:33785 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966829AbXEHB0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 21:26:33 -0400
Date: Mon, 7 May 2007 18:27:36 -0700
From: Greg KH <gregkh@suse.de>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH] DMI-based module autoloading
Message-ID: <20070508012736.GA24856@suse.de>
References: <20070508005429.GA19182@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508005429.GA19182@tango.0pointer.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 02:54:29AM +0200, Lennart Poettering wrote:
> To take advantage of DMI based module autoloading, a driver should
> export one or more MODULE_ALIAS fields similar to these:
> 
> MODULE_ALIAS("dmi:*:svnMICRO-STARINT'LCO.,LTD:pnMS-1013:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
> MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1058:pvr0581:rvnMSI:rnMS-1058:*:ct10:*");
> MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1412:*:rvnMSI:rnMS-1412:*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
> MODULE_ALIAS("dmi:*:svnNOTEBOOK:pnSAM2000:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");

Is there any way to automatically generate these aliases (like we do for
PCI and USB), in a way that is easier for the developer, instead of
having to figure out how to create such a "wierd" string like these by
hand?

> These lines are specific to my msi-laptop.c driver. They are basically
> just a concatenation of a few carefully selected DMI fields with all
> potentially bad characters stripped.

What is a "bad character" here?

thanks,

greg k-h
