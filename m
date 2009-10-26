Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbZJZHE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbZJZHE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZJZHE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:04:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48162 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbZJZHE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:04:28 -0400
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, David Rientjes <rientjes@google.com>,
       Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] SGI x86_64 UV: Limit the number of number of SRAT messages
From: Andi Kleen <andi@firstfloor.org>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	<20091023233750.702443000@alcatraz.americas.sgi.com>
Date: Mon, 26 Oct 2009 08:04:31 +0100
In-Reply-To: <20091023233750.702443000@alcatraz.americas.sgi.com> (Mike Travis's message of "Fri, 23 Oct 2009 18:37:46 -0500")
Message-ID: <87pr8ay6tc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> Limit number of SRAT messages of the form:
> [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0

While I generally agree on the concept of limiting per CPU information
(see other mail) I don't think removing this message by default 
is a good idea. I regularly needed it for debugging some NUMA related
problems and they still happen moderately often even today.

I think the right approach here, to limit output, would be to figure out
a more compact output format, perhaps using a matrix in a table
or simply printing multiple pair per line.

-Andi

>
-- 
ak@linux.intel.com -- Speaking for myself only.
