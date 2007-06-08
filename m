Return-Path: <linux-kernel-owner+w=401wt.eu-S937830AbXFHFk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937830AbXFHFk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936396AbXFHFku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:40:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56954 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936297AbXFHFku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:40:50 -0400
Date: Thu, 7 Jun 2007 22:01:04 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, bk@suse.de,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bus hidden behind transparent bridge.
Message-ID: <20070608050104.GB18123@kroah.com>
References: <20070606063311.GD20745@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606063311.GD20745@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 02:33:11AM -0400, Dave Jones wrote:
> We've had this printk in drivers/pci/probe.c asking people
> to report it if they see it to linux-kernel for a long time.
> 
> google finds hundreds of instances of this being hit.
> There are a bunch in bugzilla too..
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=6783
> http://bugzilla.kernel.org/show_bug.cgi?id=7403
> http://bugzilla.kernel.org/show_bug.cgi?id=7575
> http://bugzilla.kernel.org/show_bug.cgi?id=7664
> http://bugzilla.kernel.org/show_bug.cgi?id=8074
> http://bugzilla.kernel.org/show_bug.cgi?id=8480
> 
> (possibly others, these are just a quick skim based on summary)
> 
> I don't recall ever seeing anything happen any time someone has
> reported this.  Is it worth keeping the printk there?
> It only seems to cause confusion (users think its an error,
> especially as we ask them to do something).
> 
> Better yet, I don't think I've seen a report of this where
> the user is actually experiencing a problem.
> 
> Who is the intended recipient of these reports?

They should all go to bk@suse.de as he is the one who added that line.
In fact, if he doesn't fix it up soon, I'm really tempted to just add
his email address there instead, as I'm really tired of getting these
emails and he said it would be fixed up by now...

thanks,

greg k-h
