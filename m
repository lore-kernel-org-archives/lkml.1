Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbXLLABW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbXLLABW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXLLABP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:01:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXLLABO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:01:14 -0500
Message-ID: <475F24A7.3020106@redhat.com>
Date: Tue, 11 Dec 2007 19:00:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <wtarreau@hera.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: restore missing clear_highpage
References: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2007 01:55 PM, Hugh Dickins wrote:
> tmpfs was misconverted to __GFP_ZERO in 2.6.11.  There's an unusual case in
> which shmem_getpage receives the page from its caller instead of allocating.
> We must cover this case by clear_highpage before SetPageUptodate, as before.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---

What are the symptoms of the bug this fixes?

