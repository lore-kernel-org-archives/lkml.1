Return-Path: <linux-kernel-owner+w=401wt.eu-S939524AbYCSWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939524AbYCSWGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760572AbYCSUb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:31:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57537 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609AbYCSUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:31:53 -0400
Date: Tue, 18 Mar 2008 17:45:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [13/18] Add support to allocate hugepages of different size with hugepages=...
Message-ID: <20080318164550.GF11966@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015827.15E811B41E0@basil.firstfloor.org> <20080318163225.GM23866@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318163225.GM23866@csn.ul.ie>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hmm, it's not very clear to me how hugetlb_init_hstate() would get
> called twice for the same hstate. Should it be VM_BUG_ON() if a hstate
It is called from a __setup function and the user can specify them multiple
times.  Also when the user specified the HPAGE_SIZE already and it got set up
it should not be called again.

-Andi
