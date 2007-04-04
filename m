Return-Path: <linux-kernel-owner+w=401wt.eu-S2992892AbXDDM1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992892AbXDDM1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992895AbXDDM1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:27:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:37361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992892AbXDDM1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:27:22 -0400
Date: Wed, 4 Apr 2007 14:27:01 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
Message-ID: <20070404122701.GB19587@v2.random>
References: <20070329075805.GA6852@wotan.suse.de> <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com> <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de> <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com> <20070404102407.GA529@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404102407.GA529@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 12:24:07PM +0200, Nick Piggin wrote:
> But for a potential mainline merge, maybe starting with a CONFIG
> option is a good idea -- defaulting to off, and we could start by
> turning it on just in -rc kernels for a few releases, to get a bit
> more confidence?

The only reason to do that is if there are many stupid apps pretending
to get meaningful information from pages that cannot contain any
information. The zero page in the anon page fault has been there
forever so...

Anyway I also like this approach as I immediately suggested it after
reading about the zero page scalability patches ;).
