Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbXGJBh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbXGJBh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760655AbXGJBhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:37:20 -0400
Received: from ms-smtp-04.texas.rr.com ([24.93.47.43]:46514 "EHLO
	ms-smtp-04.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552AbXGJBhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:37:18 -0400
From: Dave McCracken <dave.mccracken@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC] fsblock
Date: Mon, 9 Jul 2007 20:37:09 -0500
User-Agent: KMail/1.9.7
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
References: <20070624014528.GA17609@wotan.suse.de> <20070710005419.GB8779@wotan.suse.de> <Pine.LNX.4.64.0707091756020.2348@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707091756020.2348@schroedinger.engr.sgi.com>
Organization: Oracle Corp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707092037.10267.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007, Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> > There are no changes to the filesystem API for large pages (although I
> > am adding a couple of helpers to do page based bitmap ops). And I don't
> > want to rely on contiguous memory. Why do you think handling of large
> > pages (presumably you mean larger than page sized blocks) is strange?
>
> We already have a way to handle large pages: Compound pages.

Um, no, we don't, assuming by compound pages you mean order > 0 pages..  None 
of the stack of changes necessary to make these pages viable has yet been 
accepted, ie antifrag, defrag, and variable page cache.  While these changes 
may yet all go in and work wonderfully, I applaud Nick's alternative solution 
that does not include a depency on them.

Dave McCracken
