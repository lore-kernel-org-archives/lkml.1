Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZAIFQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZAIFQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbZAIFPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:15:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZAIFPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:15:46 -0500
Message-ID: <4966DB2A.6030708@zytor.com>
Date: Thu, 08 Jan 2009 21:05:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
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
References: <1231365115.11687.361.camel@twins>	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>	 <1231366716.11687.377.camel@twins>	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>	 <1231426014.11687.456.camel@twins>	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>	 <1231434515.14304.27.camel@think.oraclecorp.com>	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>	 <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick>	 <4966ABF9.9080409@zytor.com> <1231467896.5715.40.camel@brick>
In-Reply-To: <1231467896.5715.40.camel@brick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> A lot of code was written assuming inline means __always_inline, I'd suggest
> keeping that assumption and working on removing inlines that aren't
> strictly necessary as there's no way to know what inlines meant 'try to inline'
> and what ones really should have been __always_inline.
> 
> Not that I feel _that_ strongly about it.
> 

Actually, we have that reasonably well down by now.  There seems to be a
couple of minor tweaking still necessary, but I think we're 90-95% there
already.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

