Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZIMWQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZIMWQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 18:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZIMWQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 18:16:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43963 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZIMWQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 18:16:10 -0400
Date: Sun, 13 Sep 2009 23:15:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Shaohua Li <shaohua.li@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/4] PCI PM: Add function for checking PME status
	of devices
Message-ID: <20090913221552.GB31175@srcf.ucam.org>
References: <200909132320.05077.rjw@sisk.pl> <200909132320.58093.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909132320.58093.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 11:20:58PM +0200, Rafael J. Wysocki wrote:

> Add function pci_check_pme_status() that will check the PME status
> bit of given device and clear it along with the PME enable bit.  It
> will be necessary for PCI run-time power management.

I think the comment's slightly misleading - some PCI run-time power 
management will work without any PME code. But that's not terribly 
important.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
