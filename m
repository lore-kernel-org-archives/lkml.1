Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYH2WYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYH2WYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYH2WX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:23:58 -0400
Received: from enigma.xbill.org ([204.152.189.153]:37892 "EHLO
	enigma.xbill.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbYH2WX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:23:58 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 18:23:58 EDT
Date: Fri, 29 Aug 2008 15:15:34 -0700 (PDT)
From: Brian Wellington <bwelling@xbill.org>
X-X-Sender: bwelling@particle.ddns.nominum.com
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: Re: [patch 0/5] Nano/Microsecond resolution for select() and
 poll()
In-Reply-To: <20080829080549.6906b744@infradead.org>
Message-ID: <alpine.LFD.2.00.0808291515130.3298@particle.ddns.nominum.com>
References: <20080829080549.6906b744@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Arjan van de Ven wrote:

> Today in Linux, select() and poll() operate in jiffies resolution
> (granularity), meaning an effective resolution of 1 millisecond (HZ=1000) to
> 10 milliseconds (HZ=100). Delays shorter than this are not possible, and all
> delays are in multiples of this granularity.

Would a similar change also be useful for epoll_wait()?  It's unfortunate
that there's no way to use epoll with more than millisecond granularity,
but it seems like the same arguments could be made as with poll().

Brian
