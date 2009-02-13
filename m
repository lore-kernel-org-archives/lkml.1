Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZBMLTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZBMLTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZBMLSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:18:54 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60703 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZBMLSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:18:52 -0500
Message-ID: <49955716.3070208@in.ibm.com>
Date: Fri, 13 Feb 2009 16:48:46 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       benh@kernel.crashing.org, chandru@linux.vnet.ibm.com, paulus@samba.org,
       akpm@linux-foundation.org
Subject: Re: + powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
 added to -mm tree
References: <200812250806.mBP86LPQ018399@imap1.linux-foundation.org> <20090208204725.GA5514@cmpxchg.org> <49916691.9080807@in.ibm.com> <20090210175915.GA2541@cmpxchg.org>
In-Reply-To: <20090210175915.GA2541@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
>
> This is fine, too.  Subtracting physbase yields a smaller reserve_size
> if not page aligned (bootmem will round it up again, no problem there)
> and at the end of the loop, size is not zero.  This has no practical
> impacts, though, as far as I can see.
>
> The interesting question, however, is whether this patch actually
> fixes the problem you encountered?  If so, I would be glad if we could
> drop the workaround we currently have in -mm.
>
> 	Hannes
>   
Hello Hannes,

Yes, the patch fixes the problem of hitting the BUG_ON()
in bootmem.  Andrew removed the workaround from the
-mm tree.  Thanks to you for running your eyes on this
issue and arriving at an almost workable patch.

thanks,
Chandru
