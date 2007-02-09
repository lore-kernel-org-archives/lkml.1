Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbXBIXxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbXBIXxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXBIXxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:53:36 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:41274 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbXBIXxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:53:35 -0500
Subject: Re: DMA mapping API for non-system memory pools
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4479FB80-8703-4BCA-925E-DA25B65EE916@kernel.crashing.org>
References: <4479FB80-8703-4BCA-925E-DA25B65EE916@kernel.crashing.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 18:53:29 -0500
Message-Id: <1171065209.3627.38.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 17:33 -0600, Kumar Gala wrote:
> ideally all this would be handled via the dma mapping API, the  
> question is how to convey to the API to use the IO memory vs the  
> system memory?  Should we look at adding a new GFP_IOMEM flag or do  
> something based on struct device?
> 
> Any ideas on direction (or if this is a solved problem elsewhere)  
> would be appreciated.

Doesn't the dma_declare_coherent_memory() API work for this case?  it
was designed for the ARM SoC (and the voyager weird SCSI card).

James


