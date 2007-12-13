Return-Path: <linux-kernel-owner+w=401wt.eu-S1762042AbXLMQar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbXLMQar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbXLMQaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:30:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:35831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbXLMQai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:30:38 -0500
Date: Thu, 13 Dec 2007 08:29:36 -0800
From: Greg KH <gregkh@suse.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: htejun@gmail.com, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071213162936.GA7635@suse.de>
References: <20071213123333.GA16905@linux.vnet.ibm.com> <20071213132326.GC16905@linux.vnet.ibm.com> <20071213151847.GB5676@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213151847.GB5676@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:48:47PM +0530, Dhaval Giani wrote:
> On Thu, Dec 13, 2007 at 06:53:26PM +0530, Dhaval Giani wrote:
> > On Thu, Dec 13, 2007 at 06:03:33PM +0530, Dhaval Giani wrote:
> > > Hi Greg, Tejun,
> > > 
> > > The following script causes oomkiller to be invoked on my system here.
> > > 
> > > while echo; do cat /sys/kernel/kexec_crash_loaded; done
> > > 
> > 
> >  while echo; do cat /sys/kernel/uevent_seqnum ; done;
> > 
> > causes oomkiller to be invoked on 2.6.22-stable, 2.6.23-stable and
> > 2.6.24-rc5 as well. It seems not be particularly related to any single
> > file in sysfs.
> > 
> 
> And on 2.6.24-rc5-mm1 as well.

How long do you have to run this?  I'm not seeing a problem here with
2.6.24-rc5 using SLUB, but I might not have run things long enough.

I ran slabinfo and don't see anything leaking either, do you?

thanks,

greg k-h
