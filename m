Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZBWU1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZBWU1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbZBWU1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:27:23 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:62691 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbZBWU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CF7FSbnZylsuXkKvAU4raO+TahmpbJBv+hJDjSe/PTwQOBUZ1iVHBXQ/J/ASm7T3BC
         CE9VXzJBnkM454cwV7RJeFAku/S03yFrbYA56zmprJ4VNJep+tV9aj4iqaM8y6YWxl4y
         Hy4YcAC6menYzLxRrvBsXBRzimcChdE3x3WkA=
MIME-Version: 1.0
In-Reply-To: <20090223180134.GR6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235344649-18265-5-git-send-email-mel@csn.ul.ie>
	 <1235390101.4645.79.camel@laptop> <20090223180134.GR6740@csn.ul.ie>
Date: Mon, 23 Feb 2009 21:27:19 +0100
Message-ID: <19f34abd0902231227v687deb70r294bcf9a9b059d6@mail.gmail.com>
Subject: Re: [PATCH] mm: clean up __GFP_* flags a bit
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/23 Mel Gorman <mel@csn.ul.ie>:
> On Mon, Feb 23, 2009 at 12:55:01PM +0100, Peter Zijlstra wrote:
>> Subject: mm: clean up __GFP_* flags a bit
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Date: Mon Feb 23 12:28:33 CET 2009
>>
>> re-sort them and poke at some whitespace alignment for easier reading.
>>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> It didn't apply because we are working off different trees. I was on
> git-latest from last Wednesday and this looks to be -mm based on the presense
> of CONFIG_KMEMCHECK. I rebased and ended up with the patch below. Thanks

I will take the remaining parts and apply it to the kmemcheck tree. Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
