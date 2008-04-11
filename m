Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbYDKT3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbYDKT3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYDKT2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:28:55 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50888 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758520AbYDKT2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:28:54 -0400
Date: Fri, 11 Apr 2008 12:28:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
In-Reply-To: <20080411092452.GE10801@elte.hu>
Message-ID: <Pine.LNX.4.64.0804111228100.20334@schroedinger.engr.sgi.com>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
 <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
 <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
 <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
 <20080411092452.GE10801@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Ingo Molnar wrote:

> if this is a zone setup bug then a sanity-check could catch it right 
> where it happens - not much later in the slab code or so.

Could you post the zone setup of the system that fails? A memory map would 
be useful and full dmesg output up to the failure.

