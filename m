Return-Path: <linux-kernel-owner+w=401wt.eu-S1764151AbXKTVB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764151AbXKTVB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbXKTVBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:01:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbXKTVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:01:48 -0500
Message-ID: <47434B28.4040104@zytor.com>
Date: Tue, 20 Nov 2007 13:01:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       travis@sgi.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de> <474346DE.5050305@zytor.com> <200711202151.58310.ak@suse.de>
In-Reply-To: <200711202151.58310.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This limitation shouldn't apply to the percpu area, since gs_base can be 
>> pointed anywhere in the address space -- in effect we're always indirect.
> 
> The initial reference copy of the percpu area has to be addressed by
> the linker.
> 
> Hmm, in theory since it is not actually used by itself I suppose you could 
> move it into positive space.
> 

Positive space for absolute references, or just below -2 GB for %rip 
references; either should work.

	-hpa
