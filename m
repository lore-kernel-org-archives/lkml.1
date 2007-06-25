Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbXFYWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbXFYWGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXFYWGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:06:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:25711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbXFYWGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,460,1175497200"; 
   d="scan'208";a="243240651"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Mon, 25 Jun 2007 15:05:20 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <20070625150127.3a45f66d.akpm@linux-foundation.org>
In-Reply-To: <20070625150127.3a45f66d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706251505.21722.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 25, 2007 3:01:27 Andrew Morton wrote:
> On Mon, 25 Jun 2007 14:34:42 -0700
>
> Jesse Barnes <jesse.barnes@intel.com> wrote:
> > akpm -- this one should replace all the mtrr patches currently
> > in your tree.
>
> fear, uncertainty, doubt.
>
> box:/usr/src/25> grep mtrr series
> x86_64-mm-bug-in-i386-mtrr-initialization.patch
> x86-fix-section-mismatch-warnings-in-mtrr.patch
> i386-x86_64-trim-memory-not-covered-by-wb-mtrrs.patch
> i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix.patch
> i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix-2.patch
> i386-mtrr-clean-up-usage_table.patch
>
> Not all of those, I'm sure.  I think you're referring to the final
> four.  I guess if it doesn't compile (again) I'll find out ;)

Oops, correct.  I forgot you were carrying some MTRR patches not 
authored by me.  :)  Yeah, the last four are the ones I meant.

Thanks,
Jesse
