Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbXGCRCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbXGCRCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXGCRCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:02:42 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:58000 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbXGCRCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:02:41 -0400
Date: Tue, 3 Jul 2007 18:02:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703170233.GA25129@srcf.ucam.org>
References: <20070703160526.GA24334@srcf.ucam.org> <Pine.LNX.4.44L0.0707031255420.3936-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707031255420.3936-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:57:17PM -0400, Alan Stern wrote:
> On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > On Tue, Jul 03, 2007 at 12:03:33PM -0400, Alan Stern wrote:
> > > Quite apart from the sync() matter, _any_ synchronous call to a FUSE 
> > > filesystem during STR will cause trouble.  Even if the user task 
> > > implementing the filesystem isn't frozen, when it tries to carry out 
> > > some I/O to a suspended device it will either:
> > > 
> > > 	block until the system wakes up, or
> > 
> > For the suspend to RAM case, that sounds absolutely fine.
> 
> It's not so good when your suspend process has to wait for the call to 
> complete!

Why would it have to? Sorry, I suspect I'm missing something obvious 
here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
