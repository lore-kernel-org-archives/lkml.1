Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZALBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZALBbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZALBa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:30:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44954 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZALBaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:30:55 -0500
Message-ID: <496A9AD7.5040901@zytor.com>
Date: Sun, 11 Jan 2009 17:20:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
References: <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain> <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org>
In-Reply-To: <20090112005228.GS26290@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Weird. I wonder where this strange restriction comes from. It indeed
> makes this much less useful than it could be :/
> 

Most likely they're collapsing at too early of a stage.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

