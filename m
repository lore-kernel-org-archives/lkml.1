Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYJKJUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYJKJUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 05:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYJKJUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 05:20:22 -0400
Received: from iona.labri.fr ([147.210.8.143]:45495 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYJKJUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 05:20:22 -0400
Message-ID: <48F06FA1.8060906@inria.fr>
Date: Sat, 11 Oct 2008 11:19:29 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nathalie.furmento@labri.fr
Subject: Re: [PATCH] mm: use a radix-tree to make do_move_pages() complexity
 linear
References: <48EDF9DA.7000508@inria.fr> <48EFBBE9.5000703@linux-foundation.org> <48F069B8.6050709@inria.fr> <200810111958.12848.nickpiggin@yahoo.com.au>
In-Reply-To: <200810111958.12848.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> If you are worried about vmalloc overhead, I'd suggest testing with -mm.
> I've rewritten the vmap code so it is now slightly scalable and sane to
> use.
>   

I am actually only worried about move_pages() performance for large
buffers :) The vmalloc overhead is probably negligible against the
quadratic duration of move_pages() for dozens of MB.

Brice

