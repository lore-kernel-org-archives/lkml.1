Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYKNTd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYKNTd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYKNTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:33:18 -0500
Received: from gw.goop.org ([64.81.55.164]:44031 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYKNTdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:33:18 -0500
Message-ID: <491DD27A.30707@goop.org>
Date: Fri, 14 Nov 2008 11:33:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Xen-devel <xen-devel@lists.xensource.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 03 of 38] swiotlb: allow architectures	tooverride
 swiotlb pool allocation
References: <patchbomb.1226603398@abulafia.goop.org>	<e9f25b3bb6625ee88f9f.1226603401@abulafia.goop.org> <491D4C89.76E4.0078.0@novell.com>
In-Reply-To: <491D4C89.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Not directly related to this patch alone, but to the combined set of changes
> to swiotlb: I don't see any handling of CONFIG_HIGHMEM here (or at least
> a note that this a known limitation needing work). I mention this because
> this was the largest part of the changes I had posted long ago to make
> lib/swiotlb.c Xen-ready, and which got rejected due to their ugliness.
>   

Was that Andi's objection on the grounds that he didn't think that Xen 
should need swiotlb at all?

I have to admit I didn't follow that thread very closely (or threads, as 
I seem to remember).  Do you have a pointer to the pertinent bits?

> While perhaps less intrusive to take care of, I also didn't see an equivalent
> of the range_straddles_page_boundary() logic, without which I can't see
> how this would work in the common case.
>   
Could you be more specific?  The swiotlb allocation should be machine 
contiguous and so there's no stradding required, but I think I'm missing 
your point.

    J
