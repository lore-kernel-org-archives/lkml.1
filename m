Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbXLRSg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbXLRSg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbXLRSgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:36:20 -0500
Received: from mga07.intel.com ([143.182.124.22]:2851 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714AbXLRSgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:36:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,181,1196668800"; 
   d="scan'208";a="344498184"
Message-ID: <47680F36.9070808@linux.intel.com>
Date: Tue, 18 Dec 2007 10:19:34 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com> <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org> <47680C16.1090905@linux.intel.com> <20071218181343.GA19691@waste.org>
In-Reply-To: <20071218181343.GA19691@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> Might as well leave out the null UUID, no sense in claiming to have
> one when you don't. It's easy for a parser to cut on "^---["

one can't cut on that since that's also the start marker.
Yes it's possible to leave it out entirely, and thus have 2 different terminators over time.
No I don't think it's a good idea.
