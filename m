Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbZGPOpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbZGPOpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbZGPOpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:45:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38249 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597AbZGPOpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:45:41 -0400
Date: Thu, 16 Jul 2009 15:45:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Message-ID: <20090716144536.GB14345@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de> <20090716143828.GB13924@srcf.ucam.org> <1247755399.6606.4.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247755399.6606.4.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 02:43:19PM +0000, James Bottomley wrote:
> On Thu, 2009-07-16 at 15:38 +0100, Matthew Garrett wrote:
> > Exactly.
> 
> OK, so if this is only in relation to SATA power management, put it in
> libata and call it something like pm_capable.  That way we don't have to
> work out what to do with it for the rest of SCSI.

I have vague memories of this coming up before and it being suggested 
that it should be done at the SCSI layer instead, but I can't find that 
now. Doing it entirely in libata certainly isn't a problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
