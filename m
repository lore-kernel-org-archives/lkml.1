Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZAIWOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZAIWOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759425AbZAIWNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:13:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:51087 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759411AbZAIWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tepjAnNzFP8VVmMelIQ8VkKTHAi1eklV2eOz2W5HgbUpUz3xcPC/fdGfD3mvxRiNHT
         Db3OgTZY0EJTVfVDLSL5W9+zl4k21LIwB9ouFgi9d18daiYDWa8Leq0v1VUs9N0wYSZD
         nvN3EBXca0qXpp0PFb0qFhx3LegXSAxPaWTvE=
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.LFD.2.00.0901091404150.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org>
	 <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>
	 <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
	 <20090109204103.GA17212@elte.hu>
	 <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
	 <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>
	 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
	 <1231538387.5825.2.camel@brick>
	 <alpine.LFD.2.00.0901091404150.6528@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 14:13:33 -0800
Message-Id: <1231539213.5825.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 14:09 -0800, Linus Torvalds wrote:

> We have a few users of "__inline", but not very many. We can leave them 
> alone, or just convert them to __inline__ or inline.

Actually I sent out a series of patches which mostly went in 2.6.27-28
timeframe, that's why there's a lot fewer __inline/__inline__

Other than one more block in scsi which has been hanging out in -mm for
awhile, eliminating them should be pretty easy now.

Harvey

