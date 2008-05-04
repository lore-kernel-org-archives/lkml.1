Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYEDTN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYEDTN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYEDTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:13:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41563 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754520AbYEDTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:13:48 -0400
Date: Sun, 4 May 2008 14:13:45 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
Message-ID: <20080504191345.GD18857@sgi.com>
References: <patchbomb.1209740703@duo.random> <1489529e7b53d3f2dab8.1209740704@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489529e7b53d3f2dab8.1209740704@duo.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/Kconfig b/mm/Kconfig
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -205,3 +205,6 @@ config VIRT_TO_BUS
>  config VIRT_TO_BUS
>  	def_bool y
>  	depends on !ARCH_NO_VIRT_TO_BUS
> +
> +config MMU_NOTIFIER
> +	bool

Without some text following the bool keyword, I am not even asked for
this config setting on my ia64 build.

Thanks,
Robin
