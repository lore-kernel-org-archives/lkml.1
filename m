Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbXA3Wyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbXA3Wyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXA3Wyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:54:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXA3Wyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:54:35 -0500
Date: Tue, 30 Jan 2007 14:53:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <0E1E87C3-954C-4297-9D6C-E98BC79D68C3@oracle.com>
Message-ID: <Pine.LNX.4.64.0701301448320.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org>
 <0E1E87C3-954C-4297-9D6C-E98BC79D68C3@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jan 2007, Zach Brown wrote:
>
> I think we'll also want to flesh out the submission and completion interface
> so that we don't find ourselves frustrated with it in another 5 years.  What's
> there now is just scaffolding to support the interesting kernel-internal part.
> No doubt the kevent thread will come into play here.

Actually, the thing I like about kernel micro-threads (and that "fibril" 
name is starting to grow on me) is that I'm hoping we might be able to use 
them for that kevent thing too. And perhaps some other issues (ACPI has 
some "events" that might work with synchronously scheduled threads).

IOW, synchronous threading does have its advantages..

Btw, I noticed that you didn't Cc Ingo. Definitely worth doing. Not just 
because he's basically the normal scheduler maintainer, but also because 
he's historically been involved in things like the async filename lookup 
that the in-kernel web server thing used. EXACTLY the kinds of things 
where fibrils actually give you *much* nicer interfaces.

Ingo - see linux-kernel for the announcement and WIP patches.

			Linus
