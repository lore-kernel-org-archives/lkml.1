Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbZAHSqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbZAHSqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZAHSqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:46:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55340 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZAHSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:46:34 -0500
Date: Thu, 8 Jan 2009 20:00:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090108190038.GH496@one.firstfloor.org>
References: <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231366716.11687.377.camel@twins> <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108183306.GA22916@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll try to annotate the inline asms (there's not _that_ many of them), 
> and measure what the size impact is.

You can just use the patch I submitted and that you rejected for
most of them :)

-Andi

-- 
ak@linux.intel.com
