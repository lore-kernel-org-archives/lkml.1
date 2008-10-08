Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYJHRgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYJHRgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYJHRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:36:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57685 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbYJHRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:36:13 -0400
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] hugetlbfs: handle pages higher order than MAX_ORDER
From: Andi Kleen <andi@firstfloor.org>
References: <1223458431-12640-1-git-send-email-apw@shadowen.org>
	<1223458431-12640-2-git-send-email-apw@shadowen.org>
	<48ECDD37.8050506@linux-foundation.org>
Date: Wed, 08 Oct 2008 19:36:10 +0200
In-Reply-To: <48ECDD37.8050506@linux-foundation.org> (Christoph Lameter's message of "Wed, 08 Oct 2008 11:17:59 -0500")
Message-ID: <87ej2rt2et.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:
>
> But the memmap is contiguous in most cases. FLATMEM, VMEMMAP etc. Its only
> some special sparsemem configurations that couldhave the issue because they
> break up the vmemmap. x86_64 uses VMEMMAP by default. Is this for i386?

i386 doesn't support huge pages > MAX_ORDER. I guess it's for ppc64,
but they should probably just use vmemmap there if they don't already.

-Andi
-- 
ak@linux.intel.com
