Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbYDKTZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbYDKTZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbYDKTZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:25:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39009 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756148AbYDKTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:25:43 -0400
Date: Fri, 11 Apr 2008 12:25:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: travis@sgi.com
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
In-Reply-To: <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804111223380.20334@schroedinger.engr.sgi.com>
References: <20080411074145.GA4944@elte.hu>  <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
  <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> 
 <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Pekka Enberg wrote:

> slab bug and I don't see any recent changes to the page allocator
> either that would explain this.

I also have an internal report that x86-git causes boot to fail with an 8p 
if one starts with a x86_64 config file and then converts to 
x86_32. Somehow the NR_CPUS is set to 255 in that case. Could this 
exhaust memory? I guess the per cpu cleanup work may figure in that area.
Mike?

