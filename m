Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbZJMOgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbZJMOgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZJMOgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:36:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:33222 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbZJMOgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:36:47 -0400
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
From: James Bottomley <James.Bottomley@suse.de>
To: akataria@vmware.com
Cc: Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Bart Van Assche <bvanassche@acm.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Robert Love <robert.w.love@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
In-Reply-To: <1254789028.15233.54.camel@ank32.eng.vmware.com>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
	 <1254789028.15233.54.camel@ank32.eng.vmware.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 14:35:57 +0000
Message-Id: <1255444557.2855.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 17:30 -0700, Alok Kataria wrote:
> > Were you still planning on renaming the driver to something less generic
> > (like vmw_pvscsi)?
> 
> 
> Yep, below is a patch with the rename, the driver is now called
> vmw_pvscsi. Do let me know if you have any other comments. Thanks.

I'm still curious to know what the 'p' in the name stands for.  Surely
this is a fully virtual driver, not a paravirtual one?

James


