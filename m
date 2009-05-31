Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZEaKeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZEaKeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZEaKeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:34:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51122 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754359AbZEaKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:34:16 -0400
Date: Sun, 31 May 2009 11:34:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pageexec@freemail.hu
Cc: "Larry H." <research@subreption.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       linux-crypto@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 5/5] Apply the PG_sensitive flag to the CryptoAPI
 subsystem
Message-ID: <20090531113404.5051114d@lxorguk.ukuu.org.uk>
In-Reply-To: <4A225887.21178.1C8AE762@pageexec.freemail.hu>
References: <20090520190519.GE10756@oblivion.subreption.com>
	<20090530180540.GE20013@elte.hu>
	<4A225887.21178.1C8AE762@pageexec.freemail.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also, there's no discussion about long-lived threads keeping 
> > sensitive information in there kernel stack indefinitely.
> 
> kernel stack clearing isn't hard to do, just do it on every syscall exit
> and in the infinite loop for kernel threads.

Actually that is probably not as important. In most cases you would be
leaking data between syscalls made by the same thread. 

