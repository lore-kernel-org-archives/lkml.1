Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYHDQcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYHDQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYHDQbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:31:55 -0400
Received: from homer.mvista.com ([63.81.120.158]:1263 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYHDQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:31:54 -0400
Subject: Re: [PATCH 3/3] powerpc - Make the irq reverse mapping radix tree
	lockless
From: Daniel Walker <dwalker@mvista.com>
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, michael@ellerman.id.au, jean-pierre.dion@bull.net,
       gilles.carry@ext.bull.net, tinytim@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org
In-Reply-To: <1217848124-3719-4-git-send-email-sebastien.dugue@bull.net>
References: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
	 <1217848124-3719-4-git-send-email-sebastien.dugue@bull.net>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 09:31:36 -0700
Message-Id: <1217867496.3946.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 13:08 +0200, Sebastien Dugue wrote:

> --- a/arch/powerpc/include/asm/irq.h
> +++ b/arch/powerpc/include/asm/irq.h
> @@ -119,6 +119,7 @@ struct irq_host {
>  		} linear;
>  		struct radix_tree_root tree;
>  	} revmap_data;
> +	spinlock_t	       tree_lock;

You have a tabbing issue above..

Daniel

