Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbZJWHYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbZJWHYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZJWHYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:24:53 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:50925 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZJWHYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:24:52 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Fri, 23 Oct 2009 09:24:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-bigboss; KDE/4.3.2; i686; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockrwd@gmail.com>
References: <1394846127@web.de> <20091023133152.1a15ba69@jbarnes-x200> <1256273896.2569.10.camel@sbs-t61>
In-Reply-To: <1256273896.2569.10.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910230924.54655.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX1/woOD1QHdQCJRkRNYyzWRS+JTqBXraOS36fpih
	SwDThVUEqrn4vkWU+ZdcgFUUh5wuWAVZWvWCnPaXjYdpI+DGCe
	Lu+/33A4reooh/s+mEaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Thu, 2009-10-22 at 21:31 -0700, Jesse Barnes wrote:
> > Here's a quick & dirty version, totally untested.  A cleaner approach
> > would be to separate the WC mapping routines and hide the return
> > -EINVAL in arch specific code...
> 
> Jesse How about this patch? Doing this in x86 is cleaner.
> 
> I would like Acks/sign-offs-by Thomas, Eric and Jesse, if it is ok with
> this patch and works.

Hmm, at this point I already was more than a week ago:
  http://marc.info/?l=linux-kernel&m=125537770514713&w=2

OK, I also modified ioremap() and set_memory_wc() but your patch is just part 
of what I did there...

And Eric Anholt answered:
> Seems like we should install an MTRR instead.  Requiring userland to set
> up the MTRR on the kernel's behalf is backwards.

Where I totally agree with him.

Regards,
  Thomas
