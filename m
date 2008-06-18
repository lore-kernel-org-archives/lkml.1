Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYFRULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYFRULW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYFRULL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:11:11 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:48982 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbYFRULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:11:09 -0400
Date: Wed, 18 Jun 2008 22:10:12 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?U8OpZ3VpZXIgUsOpZ2lz?= <rseguier@e-teleport.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
	MTU change
Message-ID: <20080618201012.GA4019@electric-eye.fr.zoreil.com>
References: <20080531184615.350bac00@infradead.org> <20080603134019.df2f51d4.akpm@linux-foundation.org> <20080603215155.GA9712@electric-eye.fr.zoreil.com> <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com> <4856DA62.7080803@e-teleport.net> <20080617214538.GA6388@electric-eye.fr.zoreil.com> <48584AA4.8040801@e-teleport.net> <48593E35.1010409@e-teleport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48593E35.1010409@e-teleport.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Séguier Régis <rseguier@e-teleport.net> :
[...]
> This correction seems to work.
>
> I read somewhere pci_free_consistent (in velocity_free_dma_rings) couldn't 
> be use in a spin_lock.

Yup.

> When I move velocity_free_rings outside the spin_lock, error desappeare but 
> data transfert doesn't work after the mtu change.
> When I add velocity_give_many_rx_descs all work.

I have updated http://userweb.kernel.org/~romieu/via-velocity/2.6.26-rc6/
accordingly. Can you check whether it is fine or not ?

-- 
Ueimor
