Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYDKT1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYDKT1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbYDKT07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:26:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50813 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756886AbYDKT07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:26:59 -0400
Date: Fri, 11 Apr 2008 12:26:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@Sun.COM
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
In-Reply-To: <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804111226120.20334@schroedinger.engr.sgi.com>
References: <20080411074145.GA4944@elte.hu>  <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
  <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> 
 <20080411085411.GA10181@elte.hu>  <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Pekka Enberg wrote:

> I'd be willing to put some money on this:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b7ad149d62ffffaccb9f565dfe7e5bae739d6836

Allowing systems without node 0 is a major change for x86.

