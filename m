Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbXKGRPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbXKGRPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXKGRPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:15:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32860 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbXKGRPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:15:36 -0500
Date: Wed, 7 Nov 2007 09:07:34 -0800
From: Greg KH <greg@kroah.com>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andrew Morton <akpm@osdl.org>, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107170734.GA8358@kroah.com>
References: <20071107003454.GA13374@kroah.com> <20071107103449.GB14646@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107103449.GB14646@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 02:34:49AM -0800, Stephane Eranian wrote:
> Greg,
> 
> On Tue, Nov 06, 2007 at 04:34:54PM -0800, Greg KH wrote:
> > Here's a patch against my current tree that gets the perfmon code
> > building and hopefully working.
> > 
> Thanks for your quick help.
> 
> > Note, it needs the kobject_create_and_register() patch which is in my
> > tree, but I do not think it made it to -mm yet.  The next -mm cycle
> > should have it.
> > 
> > Also, the sysfs usage in the perfmon code is quite strange and not
> > documented at all.  Yes, there is a little bit in the documentation
> > about what a few of the files do, but there are _way_ more files and
> > even directories being created under /sys/kernel/perfmon/ that are not
> > documented at all here.
> > 
> The full documentation for /sys/kernel/perfmon is in Documentation/perfmon2.txt

That is what I was referring to, that file does not describe all of the
sysfs files in /sys/kernel/perfmon by far.

> > If you document this stuff, I think I can clean up your sysfs code a
> > lot, making things simpler, easier to extend, and easier to understand.
> > But as it is, I don't want to break anything as it's totally unknown how
> > this stuff is supposed to work...
> > 
> I certainly welcome your help.
> 
> > Hint, use the Documentation/ABI directory to document your sysfs
> > interfaces, that is what it is there for...
> > 
> I will move the description from perfmon2.txt to its own file in
> ABI/testing.

That would be great to have, thanks.

greg k-h
