Return-Path: <linux-kernel-owner+w=401wt.eu-S965303AbZLHAuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303AbZLHAuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbZLHAuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:50:24 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48421 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965258AbZLHAuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:50:23 -0500
Date: Mon, 7 Dec 2009 17:50:29 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, tj@kernel.org, linux-mm@kvack.org,
       linux-ia64@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
Message-ID: <20091208005028.GF9482@parisc-linux.org>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207153552.0fadf335.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:35:52PM -0800, Andrew Morton wrote:
> erk.  So does 2.6.32's vmalloc() actually work correctly on ia64?
> 
> Perhaps vmalloc_end wasn't a well chosen name for an arch-specific
> global variable.

Can we enable -Wshadow now?  Please?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
