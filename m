Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbXFTUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbXFTUcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXFTUcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:32:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbXFTUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:32:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Iq2izxQVkWkSasXEtIG/sIITnlSbUXYW3e1SspB6pMA5HRrwAItNSGBPNEorJm3eO
	M6UOyxhC9vajuBLnMT/Ow==
Date: Wed, 20 Jun 2007 13:28:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@hpl.hp.com>
cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
In-Reply-To: <20070620202216.GA26200@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706201326310.6935@chino.kir.corp.google.com>
References: <20070620182126.248753000@amd.com> <20070620184113.GC5874@erda.amd.com>
 <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com>
 <20070620202216.GA26200@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Stephane Eranian wrote:

> > After commenting on your first set of patches, I've been using it a little 
> > more.  In my use, these debugging messages weren't very helpful because 
> > "pfm_file_ops" can indicate pfm_mmap, pfm_read, pfm_poll, etc.  Could 
> > these be changed to be more specific based on the function they're in?
> > 
> the PFM_DBG() macro adds the CPU, function name and line number to the
> printed string.
> 

That's not the case in what I currently have in my tree, I'll go back and 
see what I'm missing.

What's the current status of the perfmon2 patchset that Robert's work is 
based on?
