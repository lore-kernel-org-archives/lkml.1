Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159Ab0A0V7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0A0V7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130Ab0A0V7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:59:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab0A0V7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:59:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3 v3] macvtap driver
Date: Wed, 27 Jan 2010 22:59:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Patrick McHardy <kaber@trash.net>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <201001271104.20607.arnd@arndb.de>
In-Reply-To: <201001271104.20607.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001272259.31158.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+dNEcBBVrB0OQZr0bCHidhpHFnBrjCv3haUd5
 T7VHLBUtVw2z8Z8r/Is+SuwT9FIGVMN0sFNLZtb7pGaaqaJusJ
 f1MCAL9W4/NU/+mc1C/Dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 January 2010, Arnd Bergmann wrote:
> There are still known problems, but unless there
> are fundamental concerns, I'd like this to go
> into net-next as an experimental driver,
> fixing up the remaining problems by 2.6.34-rc1.

I should have been more specific here. The one
really annoying problem is a reference counting
problem I introduced in one of the last changes
that prevents you from destroying a device after
it has been used.

Unfortunately, I'm still traveling after LCA,
and haven't had a chance to look into this before
sending out the patches as I had originally
planned. I've also seen crashes that are not
fully reproducible, any bug reports on those
are appreciated.

	Arnd
