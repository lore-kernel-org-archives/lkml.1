Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXGADy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXGADy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 23:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbXGADys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 23:54:48 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43219 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbXGADyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 23:54:47 -0400
Date: Sun, 1 Jul 2007 04:54:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frank Fiene <ffiene@veka.com>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       tytso@thunk.org
Message-ID: <20070701035430.GA27489@srcf.ucam.org>
References: <fa.8WY71RLqV3Tqf8TkTOMOg/ub4Cs@ifi.uio.no> <46859340.7020206@shaw.ca> <200706301946.46918.ffiene@veka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706301946.46918.ffiene@veka.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Kernel doesn't recognize complete memory
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The 945 chipset used in the Z61 can only address 4GB of physical address 
space and your BIOS is using some of this for PCI and other bits of 
hardware. That only leaves 3GB for RAM. I believe that this restriction 
is mentioned on the IBM website somewhere.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
