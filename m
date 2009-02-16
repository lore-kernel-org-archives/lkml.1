Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZBPTZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZBPTZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZBPTZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:25:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:22759 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZBPTZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VykXJTc6ZEJZHcDi3cRKGFmPvWBPl3ieb0eLBvnuvSmmn86E7oD415oUAkYTAznOOS
         6nM4dAkY4BzmgVmVhdf8l3frF6xTADYo+6HwZCWeQwZvkw8L6X5SpbWRLA+Ivvq2tAHU
         aJ5aKfW1ak1vs5hujbBRHHHWAZmPQzjrQwLBg=
MIME-Version: 1.0
In-Reply-To: <20090216184200.GA31264@csn.ul.ie>
References: <20090123154653.GA14517@wotan.suse.de>
	 <200902041748.41801.nickpiggin@yahoo.com.au>
	 <20090204152709.GA4799@csn.ul.ie>
	 <200902051459.30064.nickpiggin@yahoo.com.au>
	 <20090216184200.GA31264@csn.ul.ie>
Date: Mon, 16 Feb 2009 21:25:35 +0200
X-Google-Sender-Auth: c95a63eedf61ca20
Message-ID: <84144f020902161125r59de8a53nfe01566d20ff1658@mail.gmail.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Mon, Feb 16, 2009 at 8:42 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> Slightly later than hoped for, but here are the results of the profile
> run between the different slab allocators. It also includes information on
> the performance on SLUB with the allocator pass-thru logic reverted by commit
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=97a4871761e735b6f1acd3bc7c3bac30dae3eab9

Did you just cherry-pick the patch or did you run it with the
topic/slub/perf branch? There's a follow-up patch from Yanmin which
will make a difference for large allocations when page-allocator
pass-through is reverted:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=79b350ab63458ef1d11747b4f119baea96771a6e

                            Pekka
