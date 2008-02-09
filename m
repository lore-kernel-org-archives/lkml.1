Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYBITMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYBITMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBITMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:12:00 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:43628 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbYBITL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:11:59 -0500
Date: Sat, 9 Feb 2008 21:11:55 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
Message-ID: <20080209211155.1dd8dc3b@daedalus.pq.iki.fi>
In-Reply-To: <84144f020802091056hffc22eckbda461534e3a6072@mail.gmail.com>
References: <1201660453.8837.13.camel@brick>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	<20080205223958.2cab8ce3@daedalus.pq.iki.fi>
	<20080207125327.GB27234@elte.hu>
	<20080207125622.GA7111@infradead.org>
	<20080209195255.584d4157@daedalus.pq.iki.fi>
	<20080209100133.60406c00@laptopd505.fenrus.org>
	<20080209202353.0e83e337@daedalus.pq.iki.fi>
	<84144f020802091056hffc22eckbda461534e3a6072@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 20:56:07 +0200
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi Pekka,
> 
> On Feb 9, 2008 8:23 PM, Pekka Paalanen <pq@iki.fi> wrote:
> > By default it reserves 32 MB/cpu of relay buffers during module init.
> > It's this big based on experimentation with the nvidia proprietary driver.
> > There is no other way than unloading the module to free the buffers, or
> > even to clear them. This means that every time you start the user space
> > logger application, it gets old data first. Also poking the module
> > parameters via /sys is not allowed.
> 
> So how is mmiotrace different from, say, blktrace that has an ioctl()
> to setup/teardown the relay channels (for mmiotrace it can be a
> "status" file that does the setup/teardown when written some
> appropriate values)?

No difference. I just have to do it at some point. I can't work on this
every day and when it comes to kernel, I'm a complete newbie. So things
will take time. If people want that I fix this before mmiotrace goes into
mainline, then so be it.

blktrace, thanks for the hint, I should take a look at that.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
