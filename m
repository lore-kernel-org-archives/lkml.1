Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYGEOHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYGEOHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYGEOHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:07:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47435 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYGEOHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:07:40 -0400
Date: Sat, 5 Jul 2008 16:07:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Anvin <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: the printk problem
In-Reply-To: <19f34abd0807050650y327ca434pfca324fcccc14f06@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0807051606570.28765@fbirervta.pbzchgretzou.qr>
References: <20080705125230.GA20166@damson.getinternet.no>  <alpine.LNX.1.10.0807051518500.28765@fbirervta.pbzchgretzou.qr> <19f34abd0807050650y327ca434pfca324fcccc14f06@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-07-05 15:50, Vegard Nossum wrote:
>
>I think the most elegant solution would be a macro similar to the
>initcall macros, that adds the custom extensions to a table which is
>defined by a special linker section. This allows complete
>decentralization, but I don't think it's possible to do binary search
>on the names anymore.

With an rbtree, you can still do binary search.
