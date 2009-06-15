Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbZFOOem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbZFOOem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761314AbZFOOeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:34:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50783 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761143AbZFOOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:34:17 -0400
Date: Mon, 15 Jun 2009 15:34:11 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Li, Jiebing" <jiebing.li@intel.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>
Subject: Re: [PATCH 0/1] MMC: SDIO driver for Intel Moorestown  platform
Message-ID: <20090615143411.GA19451@srcf.ucam.org>
References: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0D@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0D@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 08:05:14PM +0800, Li, Jiebing wrote:

> 2. sdio_external_suspend_device()/sdio_external_resume_device():
> Also, similar to USB, we would like to be able to selectively suspend a particular function using sysfs interface for power management scheme (non-ACPI) if the function is not in use. 

Why? What's the UI for this going to look like? Can you detect card 
insert/eject events even when the slot is powered down?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
