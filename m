Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXGCVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXGCVUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbXGCVUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:20:10 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:46392 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbXGCVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:20:09 -0400
Date: Tue, 3 Jul 2007 22:20:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703212002.GA28895@srcf.ucam.org>
References: <20070703211227.GA28758@srcf.ucam.org> <Pine.LNX.4.44L0.0707031713530.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707031713530.8010-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 05:16:37PM -0400, Alan Stern wrote:
> On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > But that's fine - "Are we undergoing a systemwide suspend" is an easy 
> > question to ask. Freezing processes instead means that most of those 
> > paths will never be tested.
> 
> The question is easy to ask, but it's not so easy to figure out what
> you should do if the answer is Yes.  Freezing processes instead means
> that those "untested" paths -- in many, many drivers -- won't have to 
> exist at all.

We're used to the idea of applications blocking when a resource they're 
using goes away - NFS has done it forever. 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
