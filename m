Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZGPOon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZGPOon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbZGPOom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:44:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38217 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbZGPOol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:44:41 -0400
Date: Thu, 16 Jul 2009 15:44:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Message-ID: <20090716144439.GA14345@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de> <4A5F3ADE.2040109@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5F3ADE.2040109@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 04:36:14PM +0200, Stefan Richter wrote:
> Stefan Richter wrote:
> > The comment should specify what the actual effects of the flag are.
> [...]
> > (Is used by power management infrastructure to decide over runtime PM
> > policy?  I.e. don't enter power states which would prevent the port from
> > detecting/ reporting hotplug events?)
> 
> Perhaps the flag should be called differently (keep_ports_powered or
> whatever) --- unless you have additional future uses of the flag in mind
> which justify the more generic name.

Mm. I was actually wondering about that. For instance, laptop bays are 
hotpluggable but provide notification out of band and so can use ALPM 
without losing functionality. I'm not sure about "keep_ports_powered", 
but I'll try to think of something better.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
