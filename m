Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbZLHBFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbZLHBFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935734AbZLHBFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:05:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935733AbZLHBFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:05:01 -0500
Date: Mon, 7 Dec 2009 17:03:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, tj@kernel.org, linux-mm@kvack.org,
       linux-ia64@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
Message-Id: <20091207170358.eb18df96.akpm@linux-foundation.org>
In-Reply-To: <20091208005028.GF9482@parisc-linux.org>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com>
	<20091207153552.0fadf335.akpm@linux-foundation.org>
	<20091208005028.GF9482@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009 17:50:29 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Mon, Dec 07, 2009 at 03:35:52PM -0800, Andrew Morton wrote:
> > erk.  So does 2.6.32's vmalloc() actually work correctly on ia64?
> > 
> > Perhaps vmalloc_end wasn't a well chosen name for an arch-specific
> > global variable.
> 
> Can we enable -Wshadow now?  Please?
> 

That would be good.  How much mess would it make?

