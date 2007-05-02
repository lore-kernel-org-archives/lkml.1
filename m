Return-Path: <linux-kernel-owner+w=401wt.eu-S1766808AbXEBRGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766808AbXEBRGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766810AbXEBRGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:06:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766808AbXEBRGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:06:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=rDmUd5f3bxhT/b5X3eF+VG4ENtyq8yoF2216Q+1zkJdkf21Zqx+IBL3haFLvZMVc3
	Iu8LDGWtw7jwGV/AxISRg==
Date: Wed, 2 May 2007 10:05:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@novell.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 02/10] i386 pci: type may be unused
In-Reply-To: <200705021235.25993.ak@novell.com>
Message-ID: <Pine.LNX.4.64.0705021004200.2789@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <200705021235.25993.ak@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Andi Kleen wrote:

> On Wednesday 02 May 2007 06:28:22 David Rientjes wrote:
> > In the case of !CONFIG_PCI_DIRECT && !CONFIG_PCI_MMCONFIG, type is
> > unreferened.
> 
> The patch didn't compile on i386 defconfig. Fixed now but please
> compile test future patches.
> 

That's because it's dependent on the first patch in the series.

If it was fixed by replacing __attribute_unused__ with 
__attribute__((unused)), then that's fine.  __attribute_used__ would be 
wrong, however.
