Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0BEUW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:22:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36651 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0BEUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:22:26 -0500
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: Re: [PATCH] [0/4] SLAB: Fix a couple of slab memory hotadd issues
From: Andi Kleen <andi@firstfloor.org>
References: <201002031039.710275915@firstfloor.org>
	<alpine.DEB.2.00.1002051316350.25989@router.home>
Date: Fri, 05 Feb 2010 21:22:21 +0100
In-Reply-To: <alpine.DEB.2.00.1002051316350.25989@router.home> (Christoph Lameter's message of "Fri, 5 Feb 2010 13:19:48 -0600 (CST)")
Message-ID: <87636bv3eq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> On Wed, 3 Feb 2010, Andi Kleen wrote:
>
>> This fixes various problems in slab found during memory hotadd testing.
>
> It changes the bootstrap semantics. The requirement was so far that slab
> initialization must be complete before slab operations can be used.

The problem is that slab itself uses slab it initialize itself.

> This patchset allows such use before bootstrap on a node is complete and
> also allows the running of cache reaper before bootstrap is done.
>
> I have a bad feeling that this could be the result of Pekka's changes to
> the bootstrap.

Not sure I fully follow what you're saying.

Are you saying this is a regression fix after all?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
