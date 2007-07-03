Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbXGCVMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbXGCVMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXGCVMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:12:35 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:57961 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbXGCVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:12:34 -0400
Date: Tue, 3 Jul 2007 22:12:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703211227.GA28758@srcf.ucam.org>
References: <20070703202329.GA27927@srcf.ucam.org> <Pine.LNX.4.44L0.0707031708080.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707031708080.8010-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 05:10:08PM -0400, Alan Stern wrote:

> No, no -- you have it exactly backwards.  Removing the freezer turns 
> STR into something _less_ like runtime suspend, because it adds the 
> requirement that devices must not automatically be resumed when an I/O 
> request arrives.

But that's fine - "Are we undergoing a systemwide suspend" is an easy 
question to ask. Freezing processes instead means that most of those 
paths will never be tested.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
