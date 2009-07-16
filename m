Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZGPBFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZGPBFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbZGPBFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:05:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34544 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbZGPBFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:05:08 -0400
Date: Thu, 16 Jul 2009 02:05:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: ykzhao <yakui.zhao@intel.com>
Cc: Crane Cai <crane.cai@amd.com>, "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: add driver for SMBus Control Method Interface
Message-ID: <20090716010502.GA955@srcf.ucam.org>
References: <20090715060219.GA30514@crane-desktop> <1247651002.4113.9.camel@localhost.localdomain> <20090715140057.GB19054@srcf.ucam.org> <1247705174.4113.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247705174.4113.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:46:14AM +0800, ykzhao wrote:
> On Wed, 2009-07-15 at 22:00 +0800, Matthew Garrett wrote:
> > It's being accessed via ACPI methods, so the vendors have the 
> > opportunity to implement proper locking.
> If the vendors can implement the proper locking, there will be no
> conflict. 

I assume that the spec requires it.

> Another issue is that this driver had better be put in the directory of
> driver/platform/x86/.

I don't see anything x86-specific about it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
