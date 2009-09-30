Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZI3H4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZI3H4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 03:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZI3H4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 03:56:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:36034 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZI3H4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 03:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GuY4wPag73t0eQVCjBavIg66U9YjlAtuOMyUFDEbrzCc5L8q6AliOMJBIq05n31cAC
         fC29A5Z2o8DMnu9E8JyuAL33yXqzIUCIE19r6VUK7PfWzpe6kgdl04oLaBUYfZQDZzkO
         gx4APGRDU9zqeEwO0bxnX1unBeHToZnyJ2Jbc=
Date: Wed, 30 Sep 2009 09:56:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: nelakurthi koteswararao <koteswararao18@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       linux-arm-kernel@lists.infradead.org
Subject: Re: performance counter support for ARM architecture
Message-ID: <20090930075618.GA5784@nowhere>
References: <bbfde6e10909300026hbccd169s71a5ad1cd45ff944@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbfde6e10909300026hbccd169s71a5ad1cd45ff944@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 12:56:18PM +0530, nelakurthi koteswararao wrote:
> Dear all,
> 
> I will change the naming conventions and symbolic names once perfcounter for
> ARM is supported.
> I want to do intermediate releases for review in mean time
> 
> 1. I am able to support page faults in ARM with the attached patch along
> with application.( this is for linux-2.6.29 kernel)



Perf counters wasn't even in the 2.6.29 kernel so
I guess you are basing this work on a completely out of date
perf version.

We can't take patches based on 29. We can't even review
them, that doesn't make sense given the tons of things that have
changed since 2.6.29

We need patches against 2.6.32-rc1

