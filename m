Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbZJHX0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbZJHX0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbZJHX0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:26:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbZJHX0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:26:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Kd2R3z4ueGz+NYgy21qWfrLHCHiSPE6E6kk8/oO1F30A4wQcj6JNShfQyqrkEX60G
	Cpwfx2Z7zkst0xQwfANQA==
Date: Thu, 8 Oct 2009 16:24:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
       Andrew Morton <akpm@linux-foundation.org>,
       Arve Hjonnevag <arve@android.com>, San Mehat <san@android.com>
Subject: Re: [PATCH] linux-next: 20090929 - android driver build breaks
In-Reply-To: <20091008224725.GA22949@kroah.com>
Message-ID: <alpine.DEB.1.00.0910081621340.10613@chino.kir.corp.google.com>
References: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au> <20090929152027.GC4373@linux.vnet.ibm.com> <20091008224725.GA22949@kroah.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Greg KH wrote:

> > Hi Greg,
> > 
> > 	next-20090929 randconfig build breaks with
> > CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> 
> Due to no support from Google, I've dropped the android code from the
> staging tree for 2.6.33.
> 

What are you specifically referring to?  Kamalesh provided a patch[*] that 
fixes this particular compile error, which you said you were queueing.

If it's a criticism of the staleness of the Android code within the 
staging tree or no recent activity, then we should probably loop in some 
Android developers to find our about their plans.  I've added them to the 
cc.

 [*] http://marc.info/?l=linux-kernel&m=125423765013043
