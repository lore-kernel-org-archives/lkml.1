Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXGCWm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXGCWm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXGCWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:42:22 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:34551 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXGCWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:42:21 -0400
Date: Tue, 3 Jul 2007 23:42:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703224215.GA30081@srcf.ucam.org>
References: <20070703212002.GA28895@srcf.ucam.org> <Pine.LNX.4.44L0.0707031814440.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707031814440.8010-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 06:21:42PM -0400, Alan Stern wrote:
> On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > We're used to the idea of applications blocking when a resource they're 
> > using goes away - NFS has done it forever. 
> 
> You persist in evading my point.  I'm not worried about applications;  
> I'm worried about drivers.
> 
> Let me put it explicitly: You're writing a driver.  You're working on
> the read, write, or probe method.  You add code to check if a system
> sleep is underway.  Suppose the answer is Yes -- what does your driver
> do next?

Leave the process blocked and defer any i/o until after resume. Why does 
it need to be any more complicated than that?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
