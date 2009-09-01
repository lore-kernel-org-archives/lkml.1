Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZIAQel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZIAQel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088AbZIAQek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:34:40 -0400
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:16551
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932087AbZIAQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:34:40 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2009 12:34:39 EDT
Message-ID: <4A9D49CE.6080600@panasas.com>
Date: Tue, 01 Sep 2009 19:20:30 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090722 Remi/fc10 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Alok Kataria <alokkataria1@gmail.com>,
       James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com,
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
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <1251739735.16169.20.camel@ank32.eng.vmware.com> <1251741624.18828.83.camel@mulgrave.site> <1251755593.16169.51.camel@ank32.eng.vmware.com> <1251815012.3864.55.camel@mulgrave.site> <35f686220909010908k24f0164nc09b1158b6841ff3@mail.gmail.com> <20090901161306.GN22870@parisc-linux.org>
In-Reply-To: <20090901161306.GN22870@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2009 16:20:35.0340 (UTC) FILETIME=[22A0ECC0:01CA2B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2009 07:13 PM, Matthew Wilcox wrote:
> 
> Umm, we do share code between SCSI drivers.  We have the ULDs (sg, sd,
> sr, etc), we have the midlayer, and we have the transport classes (spi,
> iscsi, fc, etc).
> 

This makes a tons of sense. a scsi_transport_paravirt can have lots of common
nubs. I bet administrators would love such common management facility.

Boaz
