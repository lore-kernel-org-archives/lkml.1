Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbZFCOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbZFCOzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZFCOza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:55:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56165 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZFCOza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:55:30 -0400
Date: Wed, 3 Jun 2009 17:02:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][v2] swap: virtual swap readahead
Message-ID: <20090603150242.GB1065@one.firstfloor.org>
References: <20090602223738.GA15475@cmpxchg.org> <20090602233457.GY1065@one.firstfloor.org> <20090603132751.GA1813@cmpxchg.org> <4A268DF8.6000701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A268DF8.6000701@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not too worried about not walking the page tables,
> because swap is an extreme slow path anyway.

it was more about taking less locks and doing less mappings.
Especially highmem pte mappings can be quite expensive, because
they have to flush parts of the TLB.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
