Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYDLW0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYDLW0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 18:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYDLW0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:26:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYDLW0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:26:40 -0400
Date: Fri, 11 Apr 2008 17:23:02 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 7)
Message-ID: <20080412002302.GA27656@kroah.com>
References: <200804040111.15255.rjw@sisk.pl> <200804040112.45769.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804040112.45769.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 01:12:44AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce 'struct pm_ops' and 'struct pm_ext_ops' ('ext' meaning
> 'extended') representing suspend and hibernation operations for bus
> types, device classes, device types and device drivers.

<snip>

This is probably because I took a few days to merge this, but it doesn't
apply to my tree anymore, with some wierd merge errors that I don't
think I can easily resolve without having to totally guess as to what it
should be (the apm_32.c area especially...)

Care to respin these patches?  Sorry for the delay.

thanks,

greg k-h
