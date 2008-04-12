Return-Path: <linux-kernel-owner+w=401wt.eu-S1761369AbYDLKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369AbYDLKiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 06:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbYDLKiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 06:38:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52137 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757258AbYDLKiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:38:07 -0400
Date: Sat, 12 Apr 2008 03:38:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
In-Reply-To: <Pine.LNX.4.64.0804111228100.20334@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0804120329390.23255@schroedinger.engr.sgi.com>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
 <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
 <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
 <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
 <20080411092452.GE10801@elte.hu> <Pine.LNX.4.64.0804111228100.20334@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka pointed out the orig post that had the boot info.

One commonality in the two failures inhouse and yours is that 
both had more than 4G memory and had CONFIG_HIGHMEM4G set. Possibly
a wraparound of some limit?


