Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYILOWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYILOWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYILOWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:22:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbYILOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:22:16 -0400
Message-ID: <48CA7AE4.2080007@linux-foundation.org>
Date: Fri, 12 Sep 2008 09:21:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: Re: [PATCH] mm: make do_move_pages() complexity linear
References: <48CA611A.8060706@inria.fr> <48CA727F.1050405@linux-foundation.org> <48CA748F.8020701@inria.fr>
In-Reply-To: <48CA748F.8020701@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:

> I don't think so. If this happens, the while loop will skip those pages.
> (while in the regular case, the while loop does 0 iterations).
> The while loop is still here to make sure we are processing the right pm
> entry. What the patch changes is only that we don't uselessly look at
> the already-processed beginning of pm.

Ahh.. I missed that.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
