Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbYGOUom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbYGOUom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763504AbYGOUoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:44:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48528
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbYGOUoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:44:08 -0400
Date: Tue, 15 Jul 2008 13:44:07 -0700 (PDT)
Message-Id: <20080715.134407.150543177.davem@davemloft.net>
To: mingo@elte.hu
Cc: nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, herbert@gondor.apana.org.au
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 000000000000000e (reset_prng_context)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080715113304.GA30565@elte.hu>
References: <487BE071.80101@simon.arlott.org.uk>
	<20080715020428.GA27463@hmsendeavour.rdu.redhat.com>
	<20080715113304.GA30565@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 15 Jul 2008 13:33:04 +0200

> i have just triggered this crash too. Please, when you know about bootup 
> crashes in your code send a patch to the lkml thread so that people can 
> apply it and have a working system.
> 
> Note that the new crypto/prng.c driver has very bad quality:
> 
>   total: 45 errors, 21 warnings, 1 checks, 410 lines checked
> 
> It has tons of completely unacceptable code mistakes in it.

I think we should merge new drivers as aggressively as possible.
