Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbZFJI7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbZFJI7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbZFJI7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:59:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbZFJI7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:59:38 -0400
Date: Wed, 10 Jun 2009 10:59:39 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v5
Message-ID: <20090610085939.GE31155@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090603184648.2E2131D028F@basil.firstfloor.org> <20090609100922.GF14820@wotan.suse.de> <Pine.LNX.4.64.0906091637430.13213@sister.anvils> <20090610083803.GE6597@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610083803.GE6597@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 04:38:03PM +0800, Wu Fengguang wrote:
> On Wed, Jun 10, 2009 at 12:05:53AM +0800, Hugh Dickins wrote:
> > I think a much more sensible approach would be to follow the page
> > migration technique of replacing the page's ptes by a special swap-like
> > entry, then do the killing from do_swap_page() if a process actually
> > tries to access the page.
> 
> We call that "late kill" and will be enabled when
> sysctl_memory_failure_early_kill=0. Its default value is 1.

What's the use of this? What are the tradeoffs, in what situations
should an admin set this sysctl one way or the other?

