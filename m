Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYH2Uba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYH2Uba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYH2UbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:31:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57134 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYH2UbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:31:21 -0400
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
	corruption
From: Kasper Sandberg <lkml@metanurb.dk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <48B76CE0.5010309@goop.org>
References: <48B701FB.2020905@goop.org>
	 <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
	 <48B76CE0.5010309@goop.org>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 22:31:17 +0200
Message-Id: <1220041877.9776.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 20:28 -0700, Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
> > On Thu, Aug 28, 2008 at 12:52 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
<snip>
> Yeah, OK, but I think it should default to ON for now.  The problem is
> that we had two very different systems (Sony Vaio and Intel desktop)
> exhibit the same problem in two different ways.  These systems worked

This is very interresting. I have a gigabyte X48 board, and everything
works perfect, however, in memtest86+ i get thousands of errors in the
range 0-0.9mb. I am certain my ram is fine, i've tried it in other
computers, and reversed. I've run dozens of stress tests within my
booted linux, no trouble, also the userspace memtester (allthough im
aware it wont actually ever get to grab offending addresses).

Any thoughts?

> fine until we slightly changed the way that pagetable memory was
> allocated.  We just don't know how many other systems are doing this
> kind of subtle corruption of low memory.
> 
>     J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

