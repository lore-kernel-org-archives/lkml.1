Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbYHOTn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbYHOTn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbYHOTnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:43:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbYHOTnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:43:16 -0400
Message-ID: <48A5DC22.5010507@linux-foundation.org>
Date: Fri, 15 Aug 2008 14:42:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48986AC6.5030406@linux-foundation.org>	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48A2DD2C.3090602@linux-foundation.org>	 <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>	 <48A2F030.9080301@linux-foundation.org>	 <2f11576a0808130805s6963e2a4mbb82ad7221cf80a2@mail.gmail.com>	 <48A48B00.1090703@linux-foundation.org> <2f11576a0808150944g678f1b8di1c4d50de7358b306@mail.gmail.com> <48A5C9D8.2030507@linux-foundation.org>
In-Reply-To: <48A5C9D8.2030507@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> Setting remote_node_defrag_ratio to 100 will make slub always take the remote
> slab instead of allocating a new one.

As pointed out by Adrian D. off list:

The max remote_node_defrag_ratio is 99.

Maybe we need to change the comparison in remote_node_defrag_ratio_store() to
allow 100 to switch off any node local allocs?

