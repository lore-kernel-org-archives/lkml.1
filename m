Return-Path: <linux-kernel-owner+w=401wt.eu-S964851AbXBEWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851AbXBEWIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964852AbXBEWIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:08:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57024 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964851AbXBEWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:08:31 -0500
Date: Mon, 5 Feb 2007 22:21:23 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205222123.16a51fe6@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	<20070205084523.GA21858@elte.hu>
	<1170682488.29759.795.camel@pmac.infradead.org>
	<20070205155627.GA8354@elte.hu>
	<1170692539.29759.856.camel@pmac.infradead.org>
	<20070205162635.GA755@elte.hu>
	<20070205163152.GA2464@elte.hu>
	<Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	<1170710272.29759.894.camel@pmac.infradead.org>
	<Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
	<1170711587.29759.909.camel@pmac.infradead.org>
	<Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Really? Including the 'Scanner driver' card which arrived with my
> > scanner?
> 
> Can you read? Can you UNDERSTAND?
> 
> This is exactly my point.
> 
> If it's not obviously a SCSI card, then it shouldn't be "depends on SCSI". 
> It should be on its own and "select SCSI".

It works both ways. If I don't need to know that I must select SCSI then
it turns on easily. If I want to turn SCSI off then it causes mayhem. Two
sides of the same coin.

What is missing from the current config tools is that when you try and
turn SCSI off you can't. If there is a "really turn it off" button, then
you get told

	Disabling SCSI will disable
		USB scanner
		Foo
		Bar

	Disable Y/N

it fixes Dave's problem. 

There are great examples of this - trying to kill off the I2C bus in a
small build is one of the most painful. Yes users shouldn't need to know
to turn it on, but it does need a way to turn it back off sanely.

Alan
