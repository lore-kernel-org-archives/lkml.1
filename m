Return-Path: <linux-kernel-owner+w=401wt.eu-S970626AbXEHXyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970626AbXEHXyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967460AbXEHXy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:54:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31263 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967429AbXEHXy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:54:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=HCYG2C0HbaGsGRDjQy940Z3ZpWmz8ihpasHAD3v8EmVMa9xKOkmKIsjj9XeMn3wAi
	Z6VEF3lf3BTuRY8AbPFOw==
Date: Tue, 8 May 2007 16:54:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
In-Reply-To: <20070508161309.c398a913.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.0.99.0705081650530.28511@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
 <m3k5vj2iha.fsf@maximus.localdomain> <alpine.DEB.0.99.0705081306000.15420@chino.kir.corp.google.com>
 <20070508161309.c398a913.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Randy Dunlap wrote:

> It's already there, isn't it?  <quote from original:>
> 
> The only acceptable uses for "volatile" are:
> 
>  - in _code_, i.e., for things like the definition of "readb()" etc, where we
>    use it to force a particular access.
>  - with inline asms
>  - on "jiffies", for stupid legacy reasons
> 
> </quote>
> 
> or are you saying that you want to subject/header/title modified also?
> 

I wasn't aware that you were considering the inclusion of Linus' entire 
email in the document.  There exists a point where CodingStyle becomes so 
large that people choose not to read it in its entirety, so I was 
expecting only an addition that would explicit document the acceptable and
unacceptable uses of 'volatile' in kernel code with perhaps a link to his 
email.
