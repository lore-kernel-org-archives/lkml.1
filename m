Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXKWCHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXKWCHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 21:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXKWCHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 21:07:08 -0500
Received: from ns2.suse.de ([195.135.220.15]:37219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbXKWCHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 21:07:06 -0500
To: Robert Hancock <hancockr@shaw.ca>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [RFC] Documentation about unaligned memory access
From: Andi Kleen <andi@firstfloor.org>
References: <fa.U+CIv4JClOmn6KppLkEOSk7RW0Y@ifi.uio.no>
	<47462BBC.2000206@shaw.ca>
Date: Fri, 23 Nov 2007 03:07:05 +0100
In-Reply-To: <47462BBC.2000206@shaw.ca> (Robert Hancock's message of "Thu\, 22 Nov 2007 19\:24\:12 -0600")
Message-ID: <p73k5o9iuk6.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr@shaw.ca> writes:
>
> Also, x86 doesn't prohibit unaligned accesses,

That depends, e.g. for SSE2 they can be forbidden.

> but I believe they have
> a significant performance cost and are best avoided where possible.

On Opteron the typical cost of a misaligned access is a single cycle
and some possible penalty to load-store forwarding.

On Intel it is a bit worse, but not all that much. Unless you do 
a lot of accesses of it in a loop it's not really worth something
caring about too much.

-Andi
