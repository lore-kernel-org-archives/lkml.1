Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYJKHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYJKHtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYJKHtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:49:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbYJKHtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:49:08 -0400
Date: Sat, 11 Oct 2008 00:48:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] fastboot tree for v2.6.28
Message-Id: <20081011004840.5ad62ce0.akpm@linux-foundation.org>
In-Reply-To: <20081011064712.GA25451@elte.hu>
References: <20081010003241.GA23940@elte.hu>
	<alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org>
	<20081010154929.6ec201fe@infradead.org>
	<20081011064712.GA25451@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 08:47:12 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> When i saw your patches then initially my impression was "oh my, this 
> will break a ton of stuff", so i asked you to: make it default-off 
> (against Andrew's suggestion to just remove the config and make it a 
> compulsory feature)

hm, that must have been the other Andrew.

A feature like this I think should not have a config option but should
be enabled by a boot option.

We can waffle about the default setting of that option.  Maybe turn it
on for a few weeks and see what happens.

