Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZANSyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZANSyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZANSx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:53:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbZANSxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:53:55 -0500
Date: Wed, 14 Jan 2009 10:53:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-Id: <20090114105300.66bd014d.akpm@linux-foundation.org>
In-Reply-To: <20090114183319.GA18630@elte.hu>
References: <1231774622.4371.96.camel@laptop>
	<1231859742.442.128.camel@twins>
	<alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	<1231863710.7141.3.camel@twins>
	<1231864854.7141.8.camel@twins>
	<alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	<1231867314.7141.16.camel@twins>
	<1231952436.14825.28.camel@laptop>
	<20090114183319.GA18630@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 19:33:19 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Please pull the adaptive-mutexes-for-linus git tree

<fear>

- It seems a major shortcoming that the feature is disabled if
  CONFIG_DEBUG_MUTEXES=y.  It means that lots of people won't test it.

- When people hit performance/latency oddities, it would be nice if
  they had a /proc knob with which they could disable this feature at
  runtime.

  This would also be useful for comparative performance testing.
