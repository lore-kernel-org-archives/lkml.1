Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbZKYItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbZKYItS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933784AbZKYItS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:49:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43857 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733AbZKYItR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:49:17 -0500
To: David Miller <davem@davemloft.net>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [rfc] "fair" rw spinlocks
From: Andi Kleen <andi@firstfloor.org>
References: <20091123145409.GA29627@wotan.suse.de>
	<20091124.121959.35689494.davem@davemloft.net>
Date: Wed, 25 Nov 2009 09:49:23 +0100
In-Reply-To: <20091124.121959.35689494.davem@davemloft.net> (David Miller's message of "Tue, 24 Nov 2009 12:19:59 -0800 (PST)")
Message-ID: <87638zvvjg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
> I think nobody would notice if you changed tasklist_lock into
> a spinlock_t, and this would solve the DoS because at least on
> x86 you'd end up with the ticket spinlocks.

iirc tasklist_lock was one of them who could be potentially nested.

So just turning it into a spinlock might deadlock.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
