Return-Path: <linux-kernel-owner+w=401wt.eu-S933584AbXJPQ1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbXJPQ1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXJPQ0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:26:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbXJPQ0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:26:52 -0400
Date: Tue, 16 Oct 2007 18:26:46 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: vgoyal@in.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org
Subject: Re: [patch 0/2] Protect crashkernel against BSS overlap
Message-ID: <20071016162646.GA16521@suse.de>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	vgoyal@in.ibm.com, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, akpm@linux-foundation.org
References: <20071015115042.391348549@strauss.suse.de> <20071016054956.GA4659@in.ibm.com> <p738x63z8f8.fsf@crumb.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p738x63z8f8.fsf@crumb.suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2007-10-16 11:59]:
> Vivek Goyal <vgoyal@in.ibm.com> writes:
> 
> > Wouldn't it be better if we reserve the code, data and bss memory also
> > using bootmem allocator and when somebody tries to reserve craskernel memory
> > and if there is an overlap, boot memory allocator should scream?
> 
> Some x86 bootmem code right now relies on it not screaming (or at least not
> erroring out). That would need to be fixed first. Or you make it a flag.
> Would probably make sense, except that we already have too many bootmem
> allocation variants :/

Ok, I made a flag, see the next version of the patch.


Thanks,
   Bernhard
