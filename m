Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXDLOYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXDLOYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXDLOYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:24:46 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:44096 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbXDLOYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:24:46 -0400
Date: Thu, 12 Apr 2007 15:24:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Message-ID: <20070412142430.GA31240@srcf.ucam.org>
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412141505.GA25552@zarina>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 06:15:05PM +0400, Anton Vorontsov wrote:
> On Thu, Apr 12, 2007 at 02:08:18PM +0100, Matthew Garrett wrote:
> > ACPI batteries can report capacity and rate in either mA or mW. Given
> 
> You sure, capacity in mA? Then I don't know. But you can safely
> fallback and create your own attribute (just as in David's battery class,
> where every battery required to create its own attributes), plus create
> capacity_units attribute. So, user space will know your driver's specific
> units.

Well, mAh, but yes. Clearly it's possible to add extra attributes, but 
speccing standard attributes that don't entirely cover the most common 
non-embedded battery class seems less than ideal. Why not just require
capacity_units and rate_units attributes?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
