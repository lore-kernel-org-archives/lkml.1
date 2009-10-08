Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbZJHXbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbZJHXbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZJHXbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:31:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:52549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbZJHXbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:31:45 -0400
Date: Thu, 8 Oct 2009 16:28:25 -0700
From: Greg KH <gregkh@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
       Arve Hjonnevag <arve@android.com>, San Mehat <san@android.com>
Subject: Re: [PATCH] linux-next: 20090929 - android driver build breaks
Message-ID: <20091008232825.GA540@suse.de>
References: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au>
 <20090929152027.GC4373@linux.vnet.ibm.com>
 <20091008224725.GA22949@kroah.com>
 <alpine.DEB.1.00.0910081621340.10613@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0910081621340.10613@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 04:24:46PM -0700, David Rientjes wrote:
> On Thu, 8 Oct 2009, Greg KH wrote:
> 
> > > Hi Greg,
> > > 
> > > 	next-20090929 randconfig build breaks with
> > > CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> > 
> > Due to no support from Google, I've dropped the android code from the
> > staging tree for 2.6.33.
> > 
> 
> What are you specifically referring to?  Kamalesh provided a patch[*] that 
> fixes this particular compile error, which you said you were queueing.

Hm, I did say I was queueing it, but I still can't figure out if this is
needed for the 2.6.32 tree.  Is it?

> If it's a criticism of the staleness of the Android code within the 
> staging tree or no recent activity, then we should probably loop in some 
> Android developers to find our about their plans.  I've added them to the 
> cc.

They know all about this and agreed that the code should be dropped for
2.6.33 if no one sends me patches.  If someone does, then I will remove
my 'delete the android code' patch in the staging tree.

Honestly, I'm not holding my breath :(

thanks,

greg k-h
