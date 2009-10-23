Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbZJWJ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbZJWJ2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZJWJ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:28:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42922 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZJWJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:28:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=t3nv1W96EN3pAC1uBnYMs+Akil0N7j1M75D4VOeznYa1wt6H9XjxnwYzhefXvsJb7
	4q6AMfK5Wdu3EtYozdWzA==
Date: Fri, 23 Oct 2009 02:28:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: Alex Chiang <achiang@hp.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
In-Reply-To: <20091023042906.GC26358@kroah.com>
Message-ID: <alpine.DEB.2.00.0910230228210.28109@chino.kir.corp.google.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <alpine.DEB.2.00.0910220138380.9591@chino.kir.corp.google.com> <20091023042906.GC26358@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, Greg KH wrote:

> > I know it's long, but I think some automated scripts are eventually going 
> > to use this documentation and it's best to follow the guidelines in 
> > Documentation/ABI/README.
> 
> They are?  I don't know of any such scripts anywhere, do you?
> 

I had assumed that there were guidelines for composing the ABI documents 
so that files could eventually be matched automatically with the 
documentation to provide insight into what it does.  The only thing I 
personally use is "grep ^What:.*file Documentation/ABI/*" to find if a 
sysfs file is documented and that's because I'm not interested in all 
occurrences, just the specific documentation of that file.
