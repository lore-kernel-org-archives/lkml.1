Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZJVImm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZJVImm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 04:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZJVImm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 04:42:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZJVIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 04:42:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oI85SkdgvxIF0PHKGQKVP9STg3C0jphEAxqojYj9oC9byQHkHB+xnZtkPceXJUtKD
	q6f0/T7jh7BJy5QKdmM0g==
Date: Thu, 22 Oct 2009 01:42:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
Message-ID: <alpine.DEB.2.00.0910220138380.9591@chino.kir.corp.google.com>
References: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009, Alex Chiang wrote:

> Hi Greg, Randy,
> 
> Not sure who actually maintains Documentation/ABI/; if it's not either of
> y'all then please point me at the correct maintainer.
> 
> Anyhow, I was proposing some patches to enhance the NUMA sysfs interface:
> 
> 	http://thread.gmane.org/gmane.linux.kernel.mm/40084/
> 
> I documented my changes, but David Rientjes suggested that I take this
> as an opportunity to do a more thorough job, so here is an attempt at
> doing so by documenting at least the files that I saw on my system. Maybe
> there are more that I didn't configure in, but I think this series covers
> a good amount.
> 

Fantastic, thanks Alex!

One thing I noticed in patches 3-6 of this series is you've attached 
multiple files to a single "What:" line.  That hasn't been done before 
(ignore the style violations of sysfs-firmware-*) and I think it would be 
better to seperate each file out into its own section.

I know it's long, but I think some automated scripts are eventually going 
to use this documentation and it's best to follow the guidelines in 
Documentation/ABI/README.

Thanks again!
