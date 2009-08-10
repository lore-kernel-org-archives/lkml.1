Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZHJQLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZHJQLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZHJQLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:11:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38839 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbZHJQLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:11:48 -0400
Date: Mon, 10 Aug 2009 17:11:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org,
       shaohua.li@intel.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] SCSI: Allow platform-specific code to be run
	against the SCSI tree
Message-ID: <20090810161147.GA27277@srcf.ucam.org>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com> <20090810133815.GB22763@srcf.ucam.org> <1249916125.4089.4.camel@mulgrave.site> <20090810145809.GD24956@srcf.ucam.org> <1249920187.4089.129.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249920187.4089.129.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 11:03:07AM -0500, James Bottomley wrote:
> On Mon, 2009-08-10 at 15:58 +0100, Matthew Garrett wrote:
> > They're SCSI as far as the device tree is concerned, so the glue 
> > callbacks have to be registered from the SCSI layer. The only 
> > implementation so far is for ACPI and only covers libata, but it could 
> > potentially also be used to tie bay devices to the ofw tree on 
> > openfirmware systems.
> 
> It's hard for me to comment without seeing the scsi_platform_register
> code, but it strikes me that the only SCSI piece it's using is the
> scsi_bus ... what else is SCSI specific in there?

http://lkml.org/lkml/2009/7/13/286 is the ACPI implementation. I guess 
that it could be done entirely in libata if the bus structure is 
exported, but that does then limit it to ata - the code would need to be 
duplicated if anyone wants to bind scsi devices. I've no real 
preference, but this was the implementation suggested when I last posted 
this stuff back in 2005 or so.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
