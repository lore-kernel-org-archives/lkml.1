Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYHDRU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYHDRU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYHDRUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:20:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620AbYHDRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:20:43 -0400
Message-ID: <48973A2B.3040304@linux-foundation.org>
Date: Mon, 04 Aug 2008 12:19:39 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com>	 <20080803015847.GD26461@parisc-linux.org>	 <48970779.80902@linux-foundation.org> <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com>
In-Reply-To: <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>
> When hackbench running, SLUB consume memory very largely than SLAB.
> then, SLAB often outperform SLUB in memory stavation state.

Re memory use: If SLUB finds that there is lock contention on a slab page then
it will allocate a new one and dedicate it to a cpu in order to avoid future
contentions.

