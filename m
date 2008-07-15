Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbYGOPr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbYGOPr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbYGOPrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:47:12 -0400
Received: from gw.goop.org ([64.81.55.164]:43642 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146AbYGOPrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:47:11 -0400
Message-ID: <487CC671.3000501@goop.org>
Date: Tue, 15 Jul 2008 08:46:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: [git pull] core/percpu for v2.6.27
References: <20080714143413.GA19134@elte.hu> <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Can you explain what this does and who needs it? The percpu_xchg() looks 
> particularly pointless, since it's always a locked SMP-safe instruction on 
> x86, so a nonpreemptible load+store will likely be much faster.

The essence of those changes is to work towards unifying the i386 and 
x86-64 percpu mechanisms.  But I wasn't terribly convinced by some of 
the frills around the edges, like the xchg operation.  The work is being 
driven by Mike Travis and the huge numa people, so perhaps they have a 
use for it.

    J

