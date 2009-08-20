Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZHTLUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZHTLUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZHTLUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:20:35 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:1987 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZHTLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:20:34 -0400
Date: Thu, 20 Aug 2009 07:19:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
Message-ID: <20090820111937.GF524@hash.localnet>
References: <20090820015624.GE524@hash.localnet> <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 08:08:16AM +0300, Pekka Enberg wrote:
> Someone is stomping on SLAB internal data structures. Ext4 appears in
> both stack traces so I guess we should CC linux-ext4. How easy is it
> to reproduce this bug? One option is to try kmemcheck to see if it
> catches the problem (see Documentation/kmemcheck.txt for details).

I don't yet have a way to reproduce at will but I've anecdotally hit
this or some related bug 3 times in the last week or two without trying,
I only now captured a stack trace.  I can try some workload to exercise
the filesystem a bit more to see what turns up.

I'll try that and kmemcheck next.

-- 
Bob Copeland %% www.bobcopeland.com

