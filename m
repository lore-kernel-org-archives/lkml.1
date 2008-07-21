Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYGUPOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYGUPOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYGUPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:14:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYGUPOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:14:43 -0400
Date: Mon, 21 Jul 2008 11:14:12 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Message-ID: <20080721111412.0bfcd09b@bree.surriel.com>
In-Reply-To: <200807211549.00770.nickpiggin@yahoo.com.au>
References: <87y73x4w6y.fsf@saeurebad.de>
	<2f11576a0807201709q45aeec3cvb99b0049421245ae@mail.gmail.com>
	<20080720184843.9f7b48e9.akpm@linux-foundation.org>
	<200807211549.00770.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 15:49:00 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> It is already bad because: if you are doing a big streaming copy
> which you know is going to blow the cache and not be used again,
> then you should be unmapping behind you as you go.

MADV_SEQUENTIAL exists for a reason.

If you think that doing an automatic unmap-behind will be
a better way to go, we can certainly whip up a patch for
that...

-- 
All rights reversed.
