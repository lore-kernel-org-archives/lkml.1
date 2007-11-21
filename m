Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbXKUUN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbXKUUN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbXKUUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:12:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42706 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753911AbXKUUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:12:11 -0500
Date: Wed, 21 Nov 2007 12:12:09 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dave Hansen <haveblue@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
Subject: Re: [PATCH] Cast page_to_pfn to unsigned long in CONFIG_SPARSEMEM
In-Reply-To: <1195507183.27759.150.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711211211390.2971@schroedinger.engr.sgi.com>
References: <20071113194025.150641834@polymtl.ca>  <1195160783.7078.203.camel@localhost>
 <20071115215142.GA7825@Krystal>  <1195164977.27759.10.camel@localhost>
 <20071116144742.GA17255@Krystal>  <1195495626.27759.119.camel@localhost>
 <20071119185258.GA998@Krystal>  <1195501381.27759.127.camel@localhost>
 <20071119195257.GA3440@Krystal>  <1195502983.27759.134.camel@localhost>
 <20071119202023.GA5086@Krystal>  <20071119130801.bd7b7021.akpm@linux-foundation.org>
 <1195507183.27759.150.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Dave Hansen wrote:

> Which comes from:
>         
>         config OUT_OF_LINE_PFN_TO_PAGE
>                 def_bool X86_64
>                 depends on DISCONTIGMEM
>         
> and only on x86_64.  Perhaps it can go away with the
> discontig->sparsemem-vmemmap conversion.

The discontig/flatmem removal patch for x86_64 in mm already removes this.

