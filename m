Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYJAQrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYJAQrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYJAQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:47:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43528 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbYJAQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:47:14 -0400
Date: Wed, 1 Oct 2008 18:52:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
Message-ID: <20081001165246.GY25711@one.firstfloor.org>
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com> <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com> <48E35E83.9040101@gmail.com> <19f34abd0810010942ifef42efv6c45831789aa1293@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0810010942ifef42efv6c45831789aa1293@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But it seems that the current virt_addr_valid() doesn't take this into
> account. Should virt_addr_valid() be modified (on both x86_32 and
> x86_64) to take into account the same checks as __phys_addr() does
> when DEBUG_VIRTUAL=y? Or is it enough to use pfn_valid()?

At least in Linus' tree virt_addr_valid() is just a wrapper
around pfn_valid()


-Andi
