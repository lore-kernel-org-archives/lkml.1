Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbXLSOxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbXLSOxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXLSOxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:53:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbXLSOxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:53:34 -0500
Date: Wed, 19 Dec 2007 09:53:07 -0500
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
Message-ID: <20071219095307.683978b0@cuia.boston.redhat.com>
In-Reply-To: <1198074247.6484.17.camel@twins>
References: <20071218211539.250334036@redhat.com>
	<20071218211550.186819416@redhat.com>
	<200712191156.48507.nickpiggin@yahoo.com.au>
	<20071219084534.4fee8718@bree.surriel.com>
	<1198074247.6484.17.camel@twins>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 15:24:07 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> I thought Lee had patches that moved pages with long rmap chains (both
> anon and file) out onto the non-reclaim list, for those a slow
> background scan does make sense.

I suspect we won't be needing that code.  The SEQ replacement for
swap backed pages might reduce the number of pages that need to
be scanned to a reasonable number.

Remember, steady states are not a big problem with the current VM.
It's the sudden burst of scanning that happens when the VM decides
that it should start swapping (and every anonymous page is referenced)
that kills large systems.

-- 
All Rights Reversed
