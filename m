Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZEMLFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZEMLFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZEMLFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:05:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59755 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbZEMLFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:05:41 -0400
To: Tejun Heo <teheo@novell.com>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: remap allocator for per-CPU memory
From: Andi Kleen <andi@firstfloor.org>
References: <4A09B23B02000078000007F1@vpn.id2.novell.com>
	<4A09991E.9010903@kernel.org> <4A0A9C70.6090803@novell.com>
Date: Wed, 13 May 2009 13:05:37 +0200
In-Reply-To: <4A0A9C70.6090803@novell.com> (Tejun Heo's message of "Wed, 13 May 2009 19:09:52 +0900")
Message-ID: <87vdo5l0u6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <teheo@novell.com> writes:
>
> Okay, just glanced over the pageattr code.  I don't think we need any
> special provisions for this as long as the TLB is fine with having
> overlapping PMD and PTE mappings with different attributes (please
> note that these two mappings aren't occupying the same linear
> addresses - they're aliases).  This is allowed, right?

Nope.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
