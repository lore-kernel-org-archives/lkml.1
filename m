Return-Path: <linux-kernel-owner+w=401wt.eu-S1763855AbYBTA2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763855AbYBTA2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbYBTA2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:28:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57913
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756683AbYBTA2h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:28:37 -0500
Date: Tue, 19 Feb 2008 16:29:14 -0800 (PST)
Message-Id: <20080219.162914.197514826.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: bunk@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6.25 patch] ipv4/fib_hash.c: fix NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <47BB60E6.6030506@cosmosbay.com>
References: <20080219224951.GP31955@cs181133002.pp.htv.fi>
	<47BB60E6.6030506@cosmosbay.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 20 Feb 2008 00:06:14 +0100

> Adrian Bunk a écrit :
> > Unless I miss a guaranteed relation between between "f" and 
> > "new_fa->fa_info" this patch is required for fixing a NULL dereference
> > introduced by commit a6501e080c318f8d4467679d17807f42b3a33cd5 and 
> > spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
 ...
> Hum, you are right, kmem_cache_free() doesnt allow a NULL object, like kfree() 
> does.

Applied, thanks everyone.
