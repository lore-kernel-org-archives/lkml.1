Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYGGUcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYGGUcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbYGGUcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:32:01 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:41096 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbYGGUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vO6Gn7Wvfnj8AzOTH5InWq8J6ThhD80vOZxsMF5XqpWVNG+k4S6Q7nRhL9bdf64aa6
         sYHqArob+vP2VSYqn8iEhzGaTrl3ZKSHu6GCzvDaZ2za8TtMVc7kUjyZnpz0W7HsRHP+
         pfcVV7SfdbTw8CaVygxDYXI2Ft3iYTFRtq8Fs=
Message-ID: <19f34abd0807071331s52dc994ao6ac70e787d88227d@mail.gmail.com>
Date: Mon, 7 Jul 2008 22:31:58 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mattias Nissler" <mattias.nissler@gmx.de>
Subject: Re: [PATCH] rc80211_pid: Fix fast_start parameter handling
Cc: "Stefano Brivio" <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1215462228.4416.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807070427w5398c617uae0a4e8e40fd8f0e@mail.gmail.com>
	 <1215462228.4416.3.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 7, 2008 at 10:23 PM, Mattias Nissler <mattias.nissler@gmx.de> wrote:
> This removes the fast_start parameter from the rc_pid parameters information
> and instead uses the parameter macro when initializing the rc_pid state. Since the
> parameter is only used on initialization, there is no point of making exporting
> it via debugfs. This also fixes uninitialized memory references to the
> fast_start and norm_offset parameters.
>
> Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> ---
>
> This should fix the problem. I think this should go into mainline ASAP.

Was this code actually causing some problem/regression? If so, can we
please have a reference to bugzilla/prior conversations in the patch
description?

Was the reason for the problem known before I posted the "use of
uninitialized memory" e-mail earlier today? If no, can you please
sneak in a little reference to kmemcheck there in the patch
description? The acknowledgement is sorely needed :-)

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
