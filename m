Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYH3CzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYH3CzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYH3CzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:55:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbYH3CzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:55:00 -0400
Date: Fri, 29 Aug 2008 19:54:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 1/5] select: add a timespec version of the timeout to
 select/poll
In-Reply-To: <20080829191032.077ca1c8.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808291954120.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org> <20080829080630.5e0ea608@infradead.org> <20080829191032.077ca1c8.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Andrew Morton wrote:
> 
> It could be that two plain old writes is more efficient.  (and it could
> be that this is how the compiler implements the memset anyway?)

gcc indeed knows about memset(), and will generate just two stores. No 
worries,

		Linus
