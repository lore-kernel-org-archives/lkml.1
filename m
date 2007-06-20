Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbXFTUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbXFTUst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXFTUsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:48:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43001 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbXFTUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:48:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=MDrZ8tDpqdbK4myiSNPPQK6RaHnLj6xcIQ8PCIwQG8PUn+SUsaMuYZ7pxs0TEgO5I
	bvcDb+JNj0jWDbKPX0Rzw==
Date: Wed, 20 Jun 2007 13:45:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@hpl.hp.com>
cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
In-Reply-To: <20070620203944.GB26200@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706201341140.8396@chino.kir.corp.google.com>
References: <20070620182126.248753000@amd.com> <20070620184113.GC5874@erda.amd.com>
 <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com>
 <20070620202216.GA26200@frankl.hpl.hp.com> <alpine.DEB.0.99.0706201326310.6935@chino.kir.corp.google.com>
 <20070620203944.GB26200@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Stephane Eranian wrote:

> > What's the current status of the perfmon2 patchset that Robert's work is 
> > based on?
> 
> Well, I have been hacking on it a lot especially to allow Oprofile and
> perfmon2 to co-exist (mutual-exclusion). I am hoping to release something
> before I fly to OLS next week. I have started integrating  Robert's patches.
> I also have to integrate IBM's Cell support patch.
> 

Mutual exclusion between oprofile and perfmon2 will be great; I'm 
starting to see why you added the "implementation" field.  If you could 
integrate Robert's patches into your own then I think it will be easier 
for review from the community.
