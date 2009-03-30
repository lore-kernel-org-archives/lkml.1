Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZC3BZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZC3BZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZC3BZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:25:43 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59946 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZC3BZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:25:43 -0400
Message-ID: <49D01F94.6000101@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 10:25:40 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] issue storage dev flush from generic file_fsync helper
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org>
In-Reply-To: <20090329082507.GA4242@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Looks good except that we still need a tuning know for it.  Preferably
> one that works for these filesystems and all the existing barrier using
> ones.

Christoph, I reworked my previous fsync() patches so that what was a 
mount option to trigger a storage device writeback cache flush becomes a 
sysfs knob.

I still need to add support for automatic detection of underlying 
device's flushing capabilities but first I would like to know if you 
agree with the general approach.

I'll be replying to this email with the new patches.

- Fernando
