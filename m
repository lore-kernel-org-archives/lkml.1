Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbXERSPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbXERSPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763828AbXERSPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:15:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58972 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761513AbXERSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:15:12 -0400
Date: Fri, 18 May 2007 11:15:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <20070518051238.GA7696@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705181114470.11881@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de> <20070517.214740.51856086.davem@davemloft.net>
 <20070518051238.GA7696@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Nick Piggin wrote:

> The page->virtual thing is just a bonus (although have you seen what
> sort of hoops SPARSEMEM has to go through to find page_address?! It
> will definitely be a win on those architectures).

That is on the way out. See the discussion on virtual memmap support in 
sparseme.
