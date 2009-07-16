Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbZGPOzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbZGPOzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZGPOzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:55:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47864 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZGPOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:55:46 -0400
Date: Thu, 16 Jul 2009 15:55:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Message-ID: <20090716145542.GA14691@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de> <20090716143828.GB13924@srcf.ucam.org> <1247755399.6606.4.camel@mulgrave.site> <20090716144536.GB14345@srcf.ucam.org> <1247756009.6606.9.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247756009.6606.9.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 02:53:29PM +0000, James Bottomley wrote:

> Well, a flag that says 'hotplug' and means both the controller and bus
> support hotplugging might be SCSI specific.  However, the fact is that
> most people make such a determination on the bus type, so it's a bit
> redundant (in true SCSI there really is no controller on a hotplug bus
> that doesn't support hotplug because they can't scan the bus without
> it).  If you intend to use it to make link power management decisions,
> that's completely different because SAS PM support still isn't
> standardised and most of the rest of SCSI doesn't have it either.  So it
> sounds to me you're looking for a flag that says "might have a problem
> with SATA link power management" ... in which case this is currently
> libata specific.  We might be able to expand it to libsas if (when) we
> actually get link power management standardised, but a lot of the other
> busses aren't even going to have a concept of link power management.

Makes sense. I'll respin it as a libata feature.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
