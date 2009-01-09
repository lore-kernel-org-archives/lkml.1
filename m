Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZAIVmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZAIVmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZAIVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:42:09 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:34466 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbZAIVmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mG8XYzjmTgS8nmANsHfZHgVSKQDtzvFitXdDxco/P/fHM8lnMdvRg3yD5N+afj0tSm
         4qHhO6hAOxDgcrCD4bW5CpGmbc3CFkfPW5xdKlSliXy0DlnQWIU/a3QUkY4FGXwfOQsz
         QobJMUbQSgrC0mw+IviKSlGD+AY/MASjQsP2E=
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
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
In-Reply-To: <20090109213442.GA20051@elte.hu>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org>
	 <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>
	 <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
	 <20090109204103.GA17212@elte.hu>
	 <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
	 <20090109213442.GA20051@elte.hu>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 13:41:59 -0800
Message-Id: <1231537320.5726.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 22:34 +0100, Ingo Molnar wrote:
> The naming problem remains though:
> 
> - Perhaps we could introduce a name for the first category: __must_inline? 
>   __should_inline? Not because it wouldnt mean 'always', but because it is 
>   'always inline' for another reason than the correctless __always_inline.
> 
> - Another possible approach wuld be to rename the second category to 
>   __force_inline. That would signal it rather forcefully that the inlining 
>   there is an absolute correctness issue.

__needs_inline?  That would imply that it's for correctness reasons.

Then __always_inline is left to mean that it doesn't _need_ to be inline
but we _want_ it inline regardless of what gcc thinks?

$0.02

Harvey

