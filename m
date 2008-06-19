Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYFSUnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYFSUnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYFSUnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:43:41 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:39585 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbYFSUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:43:41 -0400
Date: Thu, 19 Jun 2008 22:43:12 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?U8OpZ3VpZXIgUsOpZ2lz?= <rseguier@e-teleport.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
	MTU change
Message-ID: <20080619204312.GA2160@electric-eye.fr.zoreil.com>
References: <20080603134019.df2f51d4.akpm@linux-foundation.org> <20080603215155.GA9712@electric-eye.fr.zoreil.com> <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com> <4856DA62.7080803@e-teleport.net> <20080617214538.GA6388@electric-eye.fr.zoreil.com> <48584AA4.8040801@e-teleport.net> <48593E35.1010409@e-teleport.net> <20080618201012.GA4019@electric-eye.fr.zoreil.com> <48598784.40306@e-teleport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48598784.40306@e-teleport.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Séguier Régis <rseguier@e-teleport.net> :
>> I have updated http://userweb.kernel.org/~romieu/via-velocity/2.6.26-rc6/
[...]
> Patch 0001 doesn't work,
>
> if I don't make a mistake skb->len is not modified in skb_pad{,to}when the 
> padding is applied. In this case, we need to attribute ETH_ZLEN to len.

Yes, that's what the driver did beforehand.

The updated serie is at the usual place. Does it perform better ?

-- 
Ueimor
