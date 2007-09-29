Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbXI2TNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbXI2TNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXI2TMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:12:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53811 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbXI2TMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:12:55 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 29 Sep 2007 12:12:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nick Piggin <npiggin@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul McKenney <paulmck@us.ibm.com>, David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch] i386: remove comment about barriers
In-Reply-To: <20070929132848.GA21169@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0709291200590.13643@alien.or.mcafeemobile.com>
References: <20070929132848.GA21169@wotan.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007, Nick Piggin wrote:

> [ This is true for x86's sfence/lfence, but raises a question about Linux's
> memory barriers. Does anybody expect that a sequence of smp_wmb and smp_rmb
> would ever provide a full smp_mb barrier? I've always assumed no, but I
> don't know if it is actually documented? ]

No, that can't be. rmb+wmb can't be considered a full mb. There was a 
recent discussion about this in the thread originated by peterz scalable 
rw_mutex patches.



- Davide


