Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYJQMg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYJQMg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYJQMgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:36:19 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42810 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYJQMgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:36:18 -0400
Message-ID: <48F886B9.8030403@davidnewall.com>
Date: Fri, 17 Oct 2008 23:06:09 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Bodo Eggert <7eggert@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       Peter Cordes <peter@cordes.ca>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: no way to swapoff a deleted swap file?
References: <bnlDw-5vQ-7@gated-at.bofh.it> <bnwpg-2EA-17@gated-at.bofh.it> <bnJFK-3bu-7@gated-at.bofh.it> <bnR0A-4kq-1@gated-at.bofh.it> <E1KqkZK-0001HO-WF@be1.7eggert.dyndns.org> <Pine.LNX.4.64.0810171250410.22374@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0810171250410.22374@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Fri, 17 Oct 2008, Bodo Eggert wrote:
>   
>> Somebody might want their swapfiles to have zero links,
>> _and_ the possibility of doing swapoff.
>>     
>
> You're right, they might, and it's not an unreasonable wish.
> But we've not supported it in the past, and I still don't
> think it's worth adding special kernel support for it now.

But it is supported now.  It's swapoff that's not supported, and I don't
think that matters.
