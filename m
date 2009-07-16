Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbZGPOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbZGPOid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbZGPOic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:38:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44810 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbZGPOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:38:31 -0400
Date: Thu, 16 Jul 2009 15:38:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Message-ID: <20090716143828.GB13924@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5F3975.70503@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 04:30:13PM +0200, Stefan Richter wrote:
> Matthew Garrett wrote:
> > @@ -447,6 +448,11 @@ struct scsi_host_template {
> >  	unsigned ordered_tag:1;
> >  
> >  	/*
> > +	 * True if host supports hotplugging
> > +	 */
> > +	unsigned hotpluggable:1;
> > +
> 
> The comment should specify what the actual effects of the flag are.
> 
> (Provides the default for Scsi_Host.hotpluggable?)

Ok.

> >  
> > +	/* 1 if hotpluggable, 0 if not */
> > +	unsigned hotpluggable:1;
> > +
> 
> Ditto here.

There's no in-kernel effect of this flag - it's just exposed to 
userspace.

> (Is used by power management infrastructure to decide over runtime PM
> policy?  I.e. don't enter power states which would prevent the port from
> detecting/ reporting hotplug events?)

Exactly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
