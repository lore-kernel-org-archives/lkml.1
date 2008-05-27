Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbYE0VlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbYE0VlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbYE0VlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:41:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:24131 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758467AbYE0VlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:41:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,550,1204531200"; 
   d="scan'208";a="285484300"
Date: Tue, 27 May 2008 14:32:02 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Theodore Tso <tytso@mit.edu>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080527143202.4bab5bf0@appleyard>
In-Reply-To: <20080527030854.GC7515@mit.edu>
References: <20080508161008.59361de5@appleyard>
	<20080527030854.GC7515@mit.edu>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 23:08:54 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, May 08, 2008 at 04:10:08PM -0700, Kristen Carlson Accardi wrote:
> > power off unused ports
> > 
> > If the port isn't either a drive bay or an external SATA port, do not 
> > keep the phy powered on if the port is unoccupied. This saves .75 watts
> > on most laptops.  A module parameter can be used to override this 
> > behavior and allow the phy's to be powered up regardless of whether it
> > has externally accessible SATA ports. 
> > 
> > Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Hi,
> 
> I'm wondering what's the status of this patch?  
> 
> if this has hit a subsystem tree yet?  0.75 watts power savings sounds
> really cool, but it doesn't seem to be in Linus's mainline yet.  Has
> it hit a subsystem tree yet, or is there some issue that still needs
> to be resolved before it can go it?
> 
> Thanks, regards,
> 
> 							- Ted
> 

Hi Ted,
As far as I know the patch has gone nowhere.  I believe that 
Jeff wanted something more flexible than the module parameter that
I provided to override the BIOS options.  I am not working on this,
I figured he had a pretty firm idea what he wanted so he was better
equipped to write the patch.

Kristen
