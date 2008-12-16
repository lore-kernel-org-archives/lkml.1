Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbYLPUvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbYLPUvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYLPUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:50:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbYLPUuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:50:54 -0500
Date: Tue, 16 Dec 2008 21:50:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: clean up asm/xen/hypervisor.h
Message-ID: <20081216205039.GF14787@elte.hu>
References: <49481173.1050901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49481173.1050901@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> hypervisor.h had accumulated a lot of crud, including lots of spurious
> #includes.  Clean it all up, and go around fixing up everything else
> accordingly.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/include/asm/xen/hypercall.h  |    6 +++++
> arch/x86/include/asm/xen/hypervisor.h |   39 ++++++---------------------------
> arch/x86/include/asm/xen/page.h       |    5 ++++
> arch/x86/xen/enlighten.c              |    1 drivers/xen/balloon.c        
>          |    4 ++-
> drivers/xen/features.c                |    6 ++++-
> drivers/xen/grant-table.c             |    1  
> include/xen/interface/event_channel.h |    2 +
> 8 files changed, 31 insertions(+), 33 deletions(-)

applied to tip/x86/xen, thanks Jeremy!

	Ingo
