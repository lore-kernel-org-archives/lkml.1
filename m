Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZIAQr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZIAQr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZIAQr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:47:28 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:50908 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbZIAQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:47:27 -0400
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Alok Kataria <alokkataria1@gmail.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Maxime Austruy <maustruy@vmware.com>,
       Bhavesh Davda <bhavesh@vmware.com>
In-Reply-To: <4A9D49CE.6080600@panasas.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
	 <1251755593.16169.51.camel@ank32.eng.vmware.com>
	 <1251815012.3864.55.camel@mulgrave.site>
	 <35f686220909010908k24f0164nc09b1158b6841ff3@mail.gmail.com>
	 <20090901161306.GN22870@parisc-linux.org>  <4A9D49CE.6080600@panasas.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 01 Sep 2009 09:47:29 -0700
Message-Id: <1251823649.16169.123.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-09-01 at 09:20 -0700, Boaz Harrosh wrote:
> On 09/01/2009 07:13 PM, Matthew Wilcox wrote:
> > 
> > Umm, we do share code between SCSI drivers.  We have the ULDs (sg, sd,
> > sr, etc), we have the midlayer, and we have the transport classes (spi,
> > iscsi, fc, etc).
> > 
> 
> This makes a tons of sense. a scsi_transport_paravirt can have lots of common
> nubs. I bet administrators would love such common management facility.

I don't see how it will help a user. VMware exports a PCI device, and
this device will be available only when running under a VMware
hypervisor. If a particular device is available the OS will use the
corresponding driver.
Please note these drivers will be used by the guest operating system,
which is running virtualized. 
I don't get what kind of control the administrator has on this ? can you
please elaborate. 

Alok
> 
> Boaz

