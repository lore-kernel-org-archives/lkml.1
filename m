Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbZJ0Uz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbZJ0Uz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932284AbZJ0Uz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:55:57 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36388 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbZJ0Uz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q6duR/4Cq4zswqza0rkgZueks9xPh8EVsFqn7m4jWfmxgPzqyGMCNUr3gIJPJZC+0b
         slYjcdldMGaqodpwTGhtG2CJMuQ4AhK93EnhU9M5BjfmLQSdpAonkW0JIkul62uEYOi2
         CzNz5wRyjaiNtCjJE2yhIR92U+jS1WdDPOGjA=
Date: Tue, 27 Oct 2009 23:55:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
Message-ID: <20091027205558.GM5893@lenovo>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Tue, Oct 27, 2009 at 01:25:51PM -0700]
| On Tue, 27 Oct 2009, Mike Travis wrote:
| 
...
| +
| +void __init acpi_numa_print_srat_mapping(void)
| +{
| +	int i, j;
| +
| +	for (i = 0; i < MAX_PXM_DOMAINS; i++) {
| +		int nid;
| +
| +		nid = pxm_to_node(i);
| +		if (nid == NUMA_NO_NODE)

Btw, David, while you at it, I just curious -- shouldn't we test it
with NID_INVAL (as pxm_to_node_map initially defined to)? Not a big
deal at all (since they are both = -1) but for the record.
Or perhaps I miss something?

| +			continue;
...

	-- Cyrill
