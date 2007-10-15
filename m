Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbXJOS5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbXJOS5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXJOS5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:57:09 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:45589 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbXJOS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:57:07 -0400
Date: Mon, 15 Oct 2007 19:56:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rob Landley <rob@landley.net>, Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Message-ID: <20071015185627.GA7236@srcf.ucam.org>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net> <20071015070022.4a0c5957@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015070022.4a0c5957@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: What still uses the block layer?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 07:00:22AM -0700, Arjan van de Ven wrote:

> that's a choice Ubuntu made in their udev scripts... if you don't like
> it, complain to them.

Keeping the naming as hda while changing the semantics (such as the 
reduced number of partitions) would have been differently confusing. We 
did look into keeping compatibility symlinks, but decided to just 
transition everything to UUIDs instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
