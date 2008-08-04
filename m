Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYHDRUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYHDRUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYHDRUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:20:12 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:30178 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYHDRUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=n62e6UQIPyQCiiblZDgQEf0/3B0NKKZEheOmT7t7ta5EXZTMWdGK65WonIBKgziLiR
         w8vhfwKVDV/ksRMWRL5zuZXN4CmnWN9qauViFtPjdfT2qnr1zZemXqRnPZMEUhskuEgF
         KZN5PqO3oXWbKluvBuBKzu6j2MIYk56ovZgHs=
Message-ID: <84144f020808041020l7d20f20fs6e090e01c00d28f0@mail.gmail.com>
Date: Mon, 4 Aug 2008 20:20:08 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>,
       "Matthew Wilcox" <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Mel Gorman" <mel@skynet.ie>, andi@firstfloor.org,
       "Rik van Riel" <riel@redhat.com>, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <489738CF.7090401@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080801182324.572058187@lameter.com>
	 <20080803015847.GD26461@parisc-linux.org>
	 <48970779.80902@linux-foundation.org>
	 <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com>
	 <489738CF.7090401@linux-foundation.org>
X-Google-Sender-Auth: 9d98354bda9ef710
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 8:13 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> KOSAKI Motohiro wrote:
>
>> When hackbench running, SLUB consume memory very largely than SLAB.
>> then, SLAB often outperform SLUB in memory stavation state.
>>
>> I don't know why memory comsumption different.
>> Anyone know it?
>
> Can you quantify the difference?
>
> SLAB buffers objects in its queues. SLUB does rely more on the page allocator.
> So SLAB may have its own reserves to fall back on.

Also, what kind of machine are we talking about here? If there are a
lot of CPUs, SLUB will allocate higher order pages more aggressively
than SLAB by default.
