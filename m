Return-Path: <linux-kernel-owner+w=401wt.eu-S1422816AbXBALpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422816AbXBALpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422825AbXBALpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:45:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422816AbXBALpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:45:23 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0701291521540.24726@blonde.wat.veritas.com> 
References: <Pine.LNX.4.64.0701291521540.24726@blonde.wat.veritas.com>  <45BDCA8A.4050809@yahoo.com.au> 
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: page_mkwrite caller is racy? 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 01 Feb 2007 11:44:59 +0000
Message-ID: <5129.1170330299@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> > Must it be able to sleep?
> 
> Not as David was using it

It absolutely *must* be able to sleep.  It has to wait for FS-Cache to finish
writing the page to the cache before letting the PTE be made writable.

David
