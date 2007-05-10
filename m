Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXEJEHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXEJEHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXEJEHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:07:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbXEJEHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:07:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=bD2ayXkUlOlv8YWmOQ+lQbC0iQvt0QIfm0uVTibQ0KsDLRFQjvcrzFnpePo8XPCFq
	10BTx6klSoXhSiZnSro4A==
Message-ID: <65dd6fd50705092106i15722e97g85f43191ceb5a3d7@mail.gmail.com>
Date: Wed, 9 May 2007 21:06:53 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [patch] removes MAX_ARG_PAGES
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
In-Reply-To: <200705092104.43353.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <65dd6fd50705060151m78bb9b4fpcb941b16a8c4709e@mail.gmail.com>
	 <20070509134815.81cb9aa9.akpm@linux-foundation.org>
	 <200705092104.43353.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Rob Landley <rob@landley.net> wrote:
> Just FYI, a really really quick and dirty way of testing this sort of thing on
> more architectures and you're likely to physically have?

Does this properly emulate caching?  On parisc, cache coherency was
the main issue we ran into.  I suspect this might be the case with
other architectures as well.

Ollie
