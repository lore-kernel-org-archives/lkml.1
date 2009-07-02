Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZGBXyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZGBXyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZGBXyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:54:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbZGBXyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:54:01 -0400
Date: Thu, 2 Jul 2009 16:53:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: David Howells <dhowells@redhat.com>, mingo@elte.hu,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: atomic64_t should be 8 bytes aligned
In-Reply-To: <4A4D2FDA.3000509@gmail.com>
Message-ID: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain>
 <4A4D2FDA.3000509@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Jul 2009, Eric Dumazet wrote:
> 
> So we probably need an __attribute__((aligned(8)) on atomic64_t definition
> as well, since alignof(atomic64_t) is 4, not 8 (!!!)

Ack. Ingo, Peter, I'm hoping you're collecting these things?

		Linus
