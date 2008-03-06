Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYCFMZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYCFMZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765921AbYCFMZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:25:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYCFMZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:25:19 -0500
Date: Thu, 6 Mar 2008 07:25:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: Re: struct pci_device_id declaration cleanups
Message-ID: <20080306122518.GB28561@infradead.org>
References: <1204800947-21569-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204800947-21569-1-git-send-email-jonas@southpole.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:55:38AM +0100, Jonas Bonn wrote:
> 
> This set of patches applies the macro DECLARE_PCI_DEVICE_TABLE to the 
> declarations of struct pci_device_id in several network drivers.  The drivers
> build cleanly with these patches (without any new warnings) on both x86 and 
> PowerPC.

Why would we want this macro?  It looks slightly ugly at least..

