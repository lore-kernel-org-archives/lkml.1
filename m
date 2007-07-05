Return-Path: <linux-kernel-owner+w=401wt.eu-S1759742AbXGENrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbXGENrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbXGENrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:47:13 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:50315 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113AbXGENrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:47:12 -0400
Date: Thu, 5 Jul 2007 14:46:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
Message-ID: <20070705134632.GA22177@srcf.ucam.org>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <E1I6Pud-0000V1-00@dorka.pomaz.szeredi.hu> <200707051523.44826.rjw@sisk.pl> <200707051528.34754.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707051528.34754.oliver@neukum.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 03:28:33PM +0200, Oliver Neukum wrote:

> If, at a minimum, we can determine that we can STD without a freezer.
> It makes no sense to invest a lot of work to face the same problem
> again with STD.

I have a model for STD that avoids the need to freeze the entirity of 
userspace, but I need to find some more time to flesh it out.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
