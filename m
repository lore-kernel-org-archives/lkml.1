Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXEGFdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXEGFdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 01:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXEGFdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 01:33:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:50630 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXEGFdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 01:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ueYQBvff9lR6+L4nBjQIo0KvqclDs7D9d15Zm9EAUH6NxWKl7T8N18qeCAT8PnwfEaWJlmCGwkt2y1OaeU5vK4n4E6EAEw9jYOYVMoQhvgrdL1NXrili/YXJ4s6eFqShSOvjQMTbsMK8ejZadsMOSAKBwg2wswHaNRKscxwWG2Y=
Message-ID: <a36005b50705062233q2ea1ef3akfa9f182f982e49ec@mail.gmail.com>
Date: Sun, 6 May 2007 22:33:48 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Davi Arnaut" <davi@haxent.com.br>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070506125451.aac4b68f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
	 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
	 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
	 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
	 <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
	 <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
	 <Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
	 <a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
	 <20070506125451.aac4b68f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> What is your position on the timerfd/signalfd/etc patches?
>
> Seems to me that if we were to have fancy new event-delivery machinery
> like kevent then the timerfd/signalfd work is heading in the other
> direction and ultimately would prove to have been unneeded?

That's my point.  I think we ultimately have to have something like
kevent and then all this *fd() work is unnecessary and just adds code
to the kernel which has to be kept around and which might hinder
further work in this area.
