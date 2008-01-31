Return-Path: <linux-kernel-owner+w=401wt.eu-S1765963AbYAaJfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765963AbYAaJfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbYAaJfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:35:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60445 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYAaJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:35:32 -0500
Subject: Re: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hugh@veritas.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       npiggin@suse.de, riel@redhat.com, mztabzr@0pointer.de, mpm@selenic.com
In-Reply-To: <20080131011227.257b9437.akpm@linux-foundation.org>
References: <1201714139.28547.237.camel@lappy>
	 <20080130144049.73596898.akpm@linux-foundation.org>
	 <1201769040.28547.245.camel@lappy>
	 <20080131011227.257b9437.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 10:35:18 +0100
Message-Id: <1201772118.28547.254.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 01:12 -0800, Andrew Morton wrote:

> Implementation-wise: make_pages_present() _can_ be converted to do this. 
> But it's a lot of patching, and the result will be a cleaner, faster and
> smaller core MM.  Whereas your approach is easy, but adds more code and
> leaves the old stuff slow-and-dirty.
> 
> Guess which approach is preferred? ;)

Ok, I'll look at using make_pages_present().

