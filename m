Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbXLTHTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbXLTHTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXLTHTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:19:01 -0500
Received: from relay2.sgi.com ([192.48.171.30]:60209 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753797AbXLTHTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:19:00 -0500
Date: Wed, 19 Dec 2007 23:19:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
In-Reply-To: <200712191156.48507.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0712192317420.13118@schroedinger.engr.sgi.com>
References: <20071218211539.250334036@redhat.com> <20071218211550.186819416@redhat.com>
 <200712191156.48507.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, Nick Piggin wrote:

> These mlocked pages don't need to be on a non-reclaimable list,
> because we can find them again via the ptes when they become
> unlocked, and there is no point background scanning them, because
> they're always going to be locked while they're mlocked.

But there is something to be said for having a consistent scheme. Here we 
already introduce address space flags for one kind of unreclaimability. 
Isnt it possible to come up with a way to categorize pages that works 
(mostly) the same way for all types of pages with reclaim issues?

