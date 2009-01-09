Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZAITdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZAITdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZAITdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:33:00 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:5283 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZAITc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:32:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XCwk1OL9AIMDfqu3quX1ZAvvzCPGYQow+aAJ9S8HhMNpFuLrkk9tgrUgoBfFj80Kix
         qbdOkOfU88g5BTvZdYucElsDMF+m9obS7LtkIRd7Woc0GXdmQcWuwRGz2BG4hKCSNqQZ
         EAKB9KwhBFx5biYKDQl40yaPADSqXeTPlmjJg=
Message-ID: <84fc9c000901091132k4f5d71a3m8efe77f9b8889270@mail.gmail.com>
Date: Fri, 9 Jan 2009 20:32:56 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Dirk Hohndel" <hohndel@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "jim owens" <jowens@hp.com>, "Chris Mason" <chris.mason@oracle.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       "Peter Morreale" <pmorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, jh@suse.cz
In-Reply-To: <20090109194026.GM26290@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090109084620.3c711aad@infradead.org>
	 <20090109172801.GC6936@parisc-linux.org>
	 <20090109174719.GG26290@one.firstfloor.org>
	 <20090109173914.GD6936@parisc-linux.org>
	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
	 <20090109181952.GI26290@one.firstfloor.org>
	 <84fc9c000901091059v65265413wda053d3ce5b0d17a@mail.gmail.com>
	 <20090109192158.GK26290@one.firstfloor.org>
	 <84fc9c000901091110n2f5565b7mecf9acec35cf5a0@mail.gmail.com>
	 <20090109194026.GM26290@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 8:40 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Fri, Jan 09, 2009 at 08:10:20PM +0100, Richard Guenther wrote:
>> On Fri, Jan 9, 2009 at 8:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> GCC 4.3 should be good in compiling the
>> >> kernel with default -Os settings.
>> >
>> > It's unfortunately not. It doesn't inline a lot of simple asm() inlines
>> > for example.
>>
>> Reading Ingos posting with the actual numbers states the opposite.
>
> Hugh had some numbers upto 4.4.0 20090102 in
>
> http://thread.gmane.org/gmane.linux.kernel/775254/focus=777231
>
> which demonstrated the problem.

How about GCC bugzillas with testcases that we can fix and enter into the
testsuite to make sure future GCC versions won't regress?

Richard.
