Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZJZHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZJZHK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZJZHK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:10:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37614 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZJZHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:10:27 -0400
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init failures
From: Andi Kleen <andi@firstfloor.org>
References: <20091023012158.177308035@sequoia.sous-sol.org>
Date: Mon, 26 Oct 2009 08:10:31 +0100
In-Reply-To: <20091023012158.177308035@sequoia.sous-sol.org> (Chris Wright's message of "Thu, 22 Oct 2009 18:21:58 -0700")
Message-ID: <87hbtmy6jc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright <chrisw@sous-sol.org> writes:

> This short series gives us the ability to allocate the swiotlb and then
> conditionally free it if we discover it isn't needed.  This allows us to
> put swiotlb to use when the hw iommu fails to initialize properly.
>
> This needs some changes to the bootmem allocator to give the ability to
> free reserved bootmem directly to the page allocator after bootmem is
> torn down.

You forgot to state what motivated you to that change?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
