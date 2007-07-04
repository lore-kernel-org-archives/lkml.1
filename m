Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXGDO6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXGDO6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXGDO6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:58:32 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:37490 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbXGDO6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:58:31 -0400
Date: Wed, 4 Jul 2007 15:58:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070704145818.GA7784@srcf.ucam.org>
References: <20070703224215.GA30081@srcf.ucam.org> <Pine.LNX.4.44L0.0707041030540.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707041030540.25704-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 10:38:47AM -0400, Alan Stern wrote:

> Okay, I agree that (1) can be handled without too much effort.  But 
> doing it adds an extra test to _every_ driver's I/O pathway.  Freezing 
> userspace does not incur all this additional overhead.

For runtime PM to work it's already necessary to have a test in that 
path to check if the device is suspended. I can't see how this adds any 
overhead to the common case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
