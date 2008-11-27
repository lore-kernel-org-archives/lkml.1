Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYK0SCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYK0SCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYK0SBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:01:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:62239 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYK0SBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:01:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,676,1220252400"; 
   d="scan'208";a="364975142"
Message-ID: <492EE087.80708@linux.intel.com>
Date: Thu, 27 Nov 2008 10:01:43 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: oops/warning report for the week of November 26, 2008
References: <492DD792.6080302@linux.intel.com> <20081127115236.GE29013@elte.hu>
In-Reply-To: <20081127115236.GE29013@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> Rank 8: mtrr_trim_uncached_memory (warning)
>> 	Reported 227 times (619 total reports)
>> 	There is a high number of machines where our MTRR checks 
>> 	trigger. I suspect we are too picky in accepting the MTRR 
>> 	configuration.
> 
> the warning here means: "the BIOS messed up but we fixed it up for 
> you just fine".

I don't believe that right now.
we see so many of these, including many "there's no MTRRs at all",
that I am seriously suspecting that our code is just incorrect somehow
and triggering too much.

