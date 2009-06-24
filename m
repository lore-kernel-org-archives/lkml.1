Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZFXMTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZFXMTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZFXMTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:19:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62212 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZFXMTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:19:03 -0400
Date: Wed, 24 Jun 2009 15:16:08 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Deak Imre (Nokia-D/Helsinki)" <imre.deak@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       "Valkeinen Tomi (Nokia-D/Helsinki)" <Tomi.Valkeinen@nokia.com>
Subject: Re: [PATCH 16/20] omapfb: dispc: Allow multiple external IRQ
 handlers
Message-ID: <20090624121608.GA17604@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <a9da40529f3dc3d0bf304c4d15cb45f1af8ae150.1245842329.git.imre.deak@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9da40529f3dc3d0bf304c4d15cb45f1af8ae150.1245842329.git.imre.deak@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 24 Jun 2009 12:17:46.0163 (UTC) FILETIME=[C8383030:01C9F4C5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 01:33:41PM +0200, Deak Imre (Nokia-D/Helsinki) wrote:
> From: Daniel Stone <daniel.stone@nokia.com>
> 
> Previously, the only external (to dispc.c) IRQ handler was RFBI's
> frame done handler.  dispc's IRQ framework was very dumb: you could only
> have one handler, and the semantics of {request,free}_irq were odd, to
> say the least.
> 
> The new framework allows multiple consumers to register arbitrary IRQ
> masks.

No chance to use genirq ?

Then rfbi and others could simply request_irq() as usual

-- 
balbi
