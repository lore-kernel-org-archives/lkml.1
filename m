Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYE0XmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYE0XmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYE0Xly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:41:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:53353 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbYE0Xlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:41:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,551,1204531200"; 
   d="scan'208";a="569321625"
Date: Tue, 27 May 2008 16:32:51 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Theodore Tso <tytso@mit.edu>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080527163251.04054a74@appleyard>
In-Reply-To: <20080527225926.GE6843@mit.edu>
References: <20080508161008.59361de5@appleyard>
	<20080527030854.GC7515@mit.edu>
	<20080527143202.4bab5bf0@appleyard>
	<20080527225926.GE6843@mit.edu>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 18:59:26 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, May 27, 2008 at 02:32:02PM -0700, Kristen Carlson Accardi wrote:
> > 
> > As far as I know the patch has gone nowhere.  I believe that 
> > Jeff wanted something more flexible than the module parameter that
> > I provided to override the BIOS options.  I am not working on this,
> > I figured he had a pretty firm idea what he wanted so he was better
> > equipped to write the patch.
> 
> Thanks Kristen,
> 
> Can you say which laptops you had tested this on where it saved power?
> (Did you test any Thinkpads, in particular?)  I'm wondering if it's
> worth trying to forward port your patch as a private mod to my kernel;
> 30 to 40 minutes of extra battery life is nothing to sneeze at!
> 
> 						- Ted
> 

I tested this on an Intel mobile software development platform 
with a newer mobile ICH - the power savings were measured at the actual 
component (via probes on the ICH), so I did not measure the power 
savings at the wall socket, although I would expect the power savings
to be even greater on the other side of the power supply.  So in short,
yes, I think it's worth it to give it a try - the patch is pretty
unintrusive, so it should be that difficult a port to do.

