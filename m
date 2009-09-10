Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZIJXnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZIJXnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZIJXnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:43:49 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:53140 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbZIJXnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:43:46 -0400
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       James Bottomley <James.Bottomley@suse.de>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Brian King <brking@linux.vnet.ibm.com>,
       "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20090909230854.GA4495@infradead.org>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>
	 <4AA8177A.2020606@codemonkey.ws>
	 <1252533093.24633.40.camel@ank32.eng.vmware.com>
	 <4AA8284A.3010908@codemonkey.ws>  <20090909230854.GA4495@infradead.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 10 Sep 2009 16:43:49 -0700
Message-Id: <1252626229.3899.65.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph, 

On Wed, 2009-09-09 at 16:08 -0700, Christoph Hellwig wrote:
> On Wed, Sep 09, 2009 at 05:12:26PM -0500, Anthony Liguori wrote:
> > Alok Kataria wrote:
> >> I see your point, but the ring logic or the ABI that we use to
> >> communicate between the hypervisor and guest is not shared between our
> >> storage and network drivers. As a result, I don't see any benefit of
> >> separating out this ring handling mechanism, on the contrary it might
> >> just add some overhead of translating between various layers for our
> >> SCSI driver.
> >>   
> >
> > But if you separate out the ring logic, it allows the scsi logic to be  
> > shared by other paravirtual device drivers.  This is significant and  
> > important from a Linux point of view.
> 
> As someone who has been hacking on a virtio scsi prototype I don't think
> it's a good idea.

Can I take a look at your work on virtio scsi ?

>   The vmware driver is a horrible design and I don't
> think it should be merged. 

Can you be more specific ? What problems do you see in the driver or the
ABI.

>  Besides beeing a ugly driver and ABI we
> really should not support this kind of closed protocol development.
> 

Alok

