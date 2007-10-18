Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbXJRBss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbXJRBss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbXJRBsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:48:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50161 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbXJRBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:48:39 -0400
Date: Wed, 17 Oct 2007 19:48:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Matthew Wilcox <willy@debian.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 - build failure with advansys
Message-ID: <20071018014836.GC14883@parisc-linux.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47104D26.7050206@linux.vnet.ibm.com> <20071012235242.9d7daf05.akpm@linux-foundation.org> <18198.41946.697397.255427@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18198.41946.697397.255427@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 10:07:54AM +1000, Paul Mackerras wrote:
> The correct fix is to make advansys depend on CONFIG_VIRT_TO_BUS, or
> alternatively fix advansys.c properly by making it use the interfaces
> described in Documentation/DMA-mapping.txt (or the equivalent scsi
> helpers).

If you look at the git logs, you'll notice there's some progress towards
this.  It's already the case for the narrow boards.  I have a patch to
rip it all out for the wide boards, but there's clearly a bug because it
crashes my parisc machine.  Works fine on x86 though.  I can't work on
it this week because I'm travelling and the parisc machine with remote
power died on me last week.

I think I already suggested a temporary CONFIG_VIRT_TO_BUS dependency to
akpm last week.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
