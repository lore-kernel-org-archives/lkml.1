Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbZANP7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbZANP7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZANP6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:58:54 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:9333 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZANP6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:58:53 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUOIDI/VQ==
Message-ID: <496E0BBA.6040403@hartkopp.net>
Date: Wed, 14 Jan 2009 16:58:50 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PULL -tip] fixed few make headers_check warnings
References: <1231836016.3212.41.camel@jaswinder.satnam> <20090113124921.GA30400@elte.hu> <20090114154057.GC32082@uranus.ravnborg.org>
In-Reply-To: <20090114154057.GC32082@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> As they are one-liners for the most part I am fine with you handling
> them in a separate branch.
>   

Hi Sam,

i would split them up:

One big single patch only for this

-#include <asm/types.h>
+#include <linux/types.h>

and this

+#include <linux/types.h>

which is trivial.

And all the other stuff should additionally go through the maintainers hands (at least).


Oliver

