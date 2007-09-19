Return-Path: <linux-kernel-owner+w=401wt.eu-S1761711AbXISQgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761711AbXISQgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXISQfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:35:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:49964 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbXISQfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:35:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,274,1186383600"; 
   d="scan'208";a="282307397"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: Intel Memory Ordering White Paper
Date: Wed, 19 Sep 2007 09:26:54 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <20070912182622.GA16520@gallifrey>
In-Reply-To: <20070912182622.GA16520@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709190926.55200.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 12, 2007 11:26 am Dr. David Alan Gilbert wrote:
> * Jesse Barnes (jesse.barnes@intel.com) wrote:
> > FYI, we just released a new white paper describing memory ordering
> > for Intel processors:
> > http://developer.intel.com/products/processor/manuals/index.htm
> >
> > Should help answer some questions about some of the ordering
> > primitives we use on i386 and x86_64.
>
> Hi Jesse,
>   Thanks for letting everyone know about that paper, however - it
> has confused me somewhat; there seem to be differences in that
> description and that described in the 'Intel 64 and IA-32
> Architectures Software Developer's Manual' and I'd like to understand
> whether this paper is designed just to explain points or is actually
> intended to change what can be expected of the processor.
>
> That ordering doc states:
> 'Loads are not reordered with other loads'
>
> Vol3a section 7.2.1 of the architecture manual states:
>
> 'Reads can be carried out speculatively and in any order.'
>
> Is this a:
>   1) Change in the definition of the architecture that existing
> processors actually follow anyway.
>   2) A difference between what the processor does and what is visible
> to the software (the intro to this paper does seem to emphasize
> software visibility more than the architecture manual).
>   3) Some other difference I haven't spotted.

It's really both (1) and (2).  This document will become part of the 
regular manuals when the next version is published.  And yes, 
processors may do something different internally, but software can rely 
on the behavior described by the rules in the document.

Jesse
