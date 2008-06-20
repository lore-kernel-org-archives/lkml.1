Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYFTKkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYFTKkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYFTKjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:39:53 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:37739 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbYFTKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:39:52 -0400
Date: Fri, 20 Jun 2008 12:39:10 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?U8OpZ3VpZXIgUsOpZ2lz?= <rseguier@e-teleport.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
	MTU change
Message-ID: <20080620103910.GA21227@electric-eye.fr.zoreil.com>
References: <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com> <4856DA62.7080803@e-teleport.net> <20080617214538.GA6388@electric-eye.fr.zoreil.com> <48584AA4.8040801@e-teleport.net> <48593E35.1010409@e-teleport.net> <20080618201012.GA4019@electric-eye.fr.zoreil.com> <48598784.40306@e-teleport.net> <20080619204312.GA2160@electric-eye.fr.zoreil.com> <485B8542.7060204@e-teleport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <485B8542.7060204@e-teleport.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Séguier Régis <rseguier@e-teleport.net> :
[...]
> But if I generate a paquet with a size more than around 3825, the driver 
> don't send it and no paquet is send after, work again after an interface 
> down/up and until no paquet > 3825.

Does it qualify as a regression ?

-- 
Ueimor
