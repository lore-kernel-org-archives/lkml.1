Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYGZNUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYGZNUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYGZNUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:20:41 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40134 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYGZNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:20:41 -0400
Date: Sat, 26 Jul 2008 09:18:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: how about a massive reorg of the "Kernel hacking" submenu?
Message-ID: <alpine.LFD.1.10.0807260809140.3417@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  this bit of whining is inspired by the observation that the "Kernel
hacking" submenu (at least under x86) has become ridiculously long and
seems only partially ordered by topic.  so some thoughts.

  first, rename it from "Kernel hacking" to "Kernel debugging" since,
well, pretty much *everything* you can do with "make *config" can be
considered "hacking" so that submenu title isn't particularly
informative.  and once that's done, really make it related to
exclusively debugging selections, which has some implications.

  first, debugging content from elsewhere should be shifted under
here, such as "kprobes" and "markers" which currently reside under
"General setup," which seems a bit odd.  and perhaps all
profiling-related selections could be moved here as well.  (BTW, is
"Profiling support" really still EXPERIMENTAL?  just curious.)

  at the same time, some stuff could be moved *out* from under "Kernel
hacking," such as "Sample kernel code."  right now, it's buried
partway down the hacking selection list, but i think it's useful
enough to deserve its own top-level entry at the bottom of the menu.
and if it's more prominent, that would encourage more people to write
code samples, as opposed to having that selection buried in the
Hacking/Debugging submenu where people might not even see it.  (and
being able to build sample kernel code really has nothing to do with
debugging, anyway.)

  anyway, just some random thoughts from an early saturday morning
at OLS 2008, waiting for someone to show up and turn on the
$^$(*&^#)*^_# wireless.

rday

p.s.  it should go without saying that it would be nice for a newer
"Kernel debugging" submenu to collect related topics into subsubmenus
to shorten what's there, like perhaps having a single selection to
debug all mutex/spinlock-related stuff, that sort of thing.  the
current layout *desperately* needs some subsubmenus for readability.
or at least a few comments to break things up.

--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
