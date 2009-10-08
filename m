Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbZJHXtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbZJHXtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbZJHXtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:49:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45773 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbZJHXti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:49:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kFCXrVrQvNwwvQYEimfuHMZB5FyW2t9OVpEubqM8O5781EQhTlAZNKRgFZBeEsZY7
	xM9CHaH6sYd0kCpiaqW9Q==
Date: Thu, 8 Oct 2009 16:48:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <gregkh@suse.de>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
       Andrew Morton <akpm@linux-foundation.org>,
       Arve Hjonnevag <arve@android.com>, San Mehat <san@android.com>
Subject: Re: [PATCH] linux-next: 20090929 - android driver build breaks
In-Reply-To: <20091008232825.GA540@suse.de>
Message-ID: <alpine.DEB.1.00.0910081644200.14247@chino.kir.corp.google.com>
References: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au> <20090929152027.GC4373@linux.vnet.ibm.com> <20091008224725.GA22949@kroah.com> <alpine.DEB.1.00.0910081621340.10613@chino.kir.corp.google.com> <20091008232825.GA540@suse.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Greg KH wrote:

> > What are you specifically referring to?  Kamalesh provided a patch[*] that 
> > fixes this particular compile error, which you said you were queueing.
> 
> Hm, I did say I was queueing it, but I still can't figure out if this is
> needed for the 2.6.32 tree.  Is it?
> 

Yes, 28b83c5 was merged during the merge window for 2.6.32 so this needs 
to be pushed for the staging tree if it's not ripped out.

> > If it's a criticism of the staleness of the Android code within the 
> > staging tree or no recent activity, then we should probably loop in some 
> > Android developers to find our about their plans.  I've added them to the 
> > cc.
> 
> They know all about this and agreed that the code should be dropped for
> 2.6.33 if no one sends me patches.  If someone does, then I will remove
> my 'delete the android code' patch in the staging tree.
> 

I don't work with Android, but the "no support from Google" phrase caught 
my attention :)  It seems like this isn't necessarily about support or 
raised issues not being addressed, but rather about a lack of progress 
being made developmentally or a general lack of interest in upstream 
inclusion.  If it was agreed to simply remove it, that's fine, I just was 
curious about the rationale.
