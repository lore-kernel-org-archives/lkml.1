Return-Path: <linux-kernel-owner+w=401wt.eu-S1762397AbXFRKTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762397AbXFRKTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759260AbXFRKTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:19:42 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:56160 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143AbXFRKTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:19:41 -0400
To: mingo@elte.hu
CC: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, kiran@scalex86.org
In-reply-to: <20070618094414.GA8261@elte.hu> (message from Ingo Molnar on Mon,
	18 Jun 2007 11:44:14 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu> <20070618083109.GA23572@elte.hu> <E1I0ChN-0006nd-00@dorka.pomaz.szeredi.hu> <20070618091832.GA1860@elte.hu> <20070618093848.GA6880@elte.hu> <20070618094414.GA8261@elte.hu>
Message-Id: <E1I0EJc-0007El-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 12:18:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > how about the patch below? Boot-tested on 32-bit. As a side-effect 
> > this change also removes the 255 CPUs limit from the 32-bit kernel.
> 
> boot-tested on 64-bit too now.

Strange, I can't even get past the compile stage ;)

  CC      kernel/spinlock.o
{standard input}: Assembler messages:
{standard input}:207: Error: backward ref to unknown label "4:"

Miklos
