Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZCYIEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZCYIEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCYIEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:04:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34969
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbZCYIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:04:35 -0400
Date: Wed, 25 Mar 2009 01:04:22 -0700 (PDT)
Message-Id: <20090325.010422.220098828.davem@davemloft.net>
To: mingo@elte.hu
Cc: herbert@gondor.apana.org.au, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090325073349.GF25833@elte.hu>
References: <20090325002303.GA2219@gondor.apana.org.au>
	<20090324.191134.05205089.davem@davemloft.net>
	<20090325073349.GF25833@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 25 Mar 2009 08:33:49 +0100

> So if there's no definitive resolution for the real cause of the 
> bug, the plain revert looks like an acceptable interim choice for 
> .29.1 - at least as far as my systems go.

Then we get back the instant OOPS that patch fixes :-)

I'm sure Herbert will look into fixing this properly.
