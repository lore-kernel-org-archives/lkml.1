Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbXJMFcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbXJMFcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 01:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXJMFbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 01:31:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35595 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXJMFbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 01:31:52 -0400
Date: Fri, 12 Oct 2007 22:29:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Pitre <nico@cam.org>, LKML <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [GIT PULL] MMC updates
Message-Id: <20071012222929.39dcc3bd.randy.dunlap@oracle.com>
In-Reply-To: <20071012230027.606a705b@poseidon.drzeus.cx>
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
	<alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
	<20071012215513.1a4dfc7d@poseidon.drzeus.cx>
	<alpine.LFD.0.9999.0710121603080.19446@xanadu.home>
	<20071012230027.606a705b@poseidon.drzeus.cx>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 23:00:27 +0200 Pierre Ossman wrote:

> Ok, let's see if we can finally sort this out.
> 
> Please pull/cherry-pick from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus
> 
> to receive the following update:
> 
>  drivers/mmc/core/host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Pierre Ossman (1):
>       mmc: use correct unregister function for led trigger
> 
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 64fbc97..c65d203 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -143,7 +143,7 @@ void mmc_remove_host(struct mmc_host *host)
>  
>         device_del(&host->class_dev);
>  
> -       led_trigger_unregister(host->led);
> +       led_trigger_unregister_simple(host->led);
>  
>         spin_lock(&mmc_host_lock);
>         idr_remove(&mmc_host_idr, host->index);

Patch doesn't apply cleanly due to spaces instead of tabs.
Copy-and-paste ?

---
~Randy
