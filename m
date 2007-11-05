Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbXKEMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbXKEMh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXKEMhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:37:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37687 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXKEMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:37:13 -0500
Subject: Re: oops in enqueue_entity with 2.6.24-rc1-g54866f03
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071102123603.GA4988@alice>
References: <20071102123603.GA4988@alice>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 13:37:11 +0100
Message-Id: <1194266231.27652.437.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 13:36 +0100, Eric Sesterhenn wrote:
> hi,
> 
> I get the following crash with 2.6.24-rc1-g54866f03, the last version I
> tested which booted fine was 2.6.24-rc1-gb1d08ac0
> 

How reproducable is this?

If its very much reproducable, could you git bisect it, as in between
those commits you tested nothing much has changed, that is, nothing that
stands out to me.

# git log -p  b1d08ac0..54866f03 | git shortlog
David S. Miller (7):
      [SPARC64]: Fix bogus '&' conditinal in set_rtc_mmss().
      [SPARC64]: Kill unused ITAG_MASK macro in ultra.S
      [SPARC64]: Fix build failure when CONFIG_BUG is disabled.
      [SPARC64]: Fix build with CONFIG_NET disabled.
      [SPARC64]: Fix linkage of enormous kernels.
      [IRDA] IRNET: Fix build when TCGETS2 is defined.
      [SPARC64]: Update defconfig.

Ilpo J<E4>rvinen (2):
      [TCP]: Process DSACKs that reside within a SACK block
      [TCP]: Another TAGBITS -> SACKED_ACKED|LOST conversion

Linus Torvalds (1):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6

Pavel Emelyanov (13):
      [NET]: Move the sock_copy() from the header
      [NET]: Move the get_net() from sock_copy()
      [NET]: Cleanup the allocation/freeing of the sock object
      [NET]: Auto-zero the allocated sock object
      [NET]: Move some core sock setup into sk_prot_alloc
      [NET]: Make the sk_clone() lighter
      [NET]: Remove bogus zero_it argument from sk_alloc
      [NET]: Forget the zero_it argument of sk_alloc()
      [NETNS]: Make the init/exit hooks checks outside the loop
      [NET]: Relax the reference counting of init_net_ns
      [NET]: Hide the dead code in the net_namespace.c
      [NET]: Mark the setup_net as __net_init
      [NET]: Hide the net_ns kmem cache

Stephen Hemminger (1):
      [NET]: docbook fixes for netif_ functions




