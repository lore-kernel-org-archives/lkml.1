Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYHZI1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYHZI1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYHZI1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:27:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43572 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYHZI1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:27:02 -0400
To: jmerkey@wolfmountaingroup.com
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       paulmck@linux.vnet.ibm.com, "Peter Zijlstra" <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, "David Howells" <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4  released
From: Andi Kleen <andi@firstfloor.org>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
	<48AD5A21.7020801@s5r6.in-berlin.de>
	<43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
	<200808212337.38626.nickpiggin@yahoo.com.au>
	<48ADD8DE.3010209@goop.org>
	<alpine.LFD.1.10.0808211415410.3487@nehalem.linux-foundation.org>
	<51467.166.70.238.43.1219551931.squirrel@webmail.wolfmountaingroup.com>
Date: Tue, 26 Aug 2008 10:26:57 +0200
In-Reply-To: <51467.166.70.238.43.1219551931.squirrel@webmail.wolfmountaingroup.com> (jmerkey@wolfmountaingroup.com's message of "Sat, 23 Aug 2008 22:25:31 -0600 (MDT)")
Message-ID: <87prnw9o6m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com writes:

> Results from Analysis of GCC volatile/memory barriers

So the result was that barrier()s actually worked? Great.

BTW if you did this work it might be worthwhile to go one further
step: gcc has a test suite where they run small programs and have a
simple facility to scan the resulting assembler code for specific
patterns. If you could bring your examples into that format (as in
being stand alone compiled and have a simple "yes/no" pattern to
check) and let it be included there that might make sure this always
keeps working in the future.

-Andi
