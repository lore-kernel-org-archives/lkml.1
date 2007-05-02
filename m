Return-Path: <linux-kernel-owner+w=401wt.eu-S1161746AbXEBIGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161746AbXEBIGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161754AbXEBIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:06:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161746AbXEBIGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:06:10 -0400
Date: Wed, 2 May 2007 01:05:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: Mark Lord <lkml@rtr.ca>, Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of
 CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
Message-Id: <20070502010527.e64dcce9.akpm@linux-foundation.org>
In-Reply-To: <1178092035.5791.349.camel@localhost.localdomain>
References: <46364EBC.5050804@rtr.ca>
	<46364F5A.2030208@rtr.ca>
	<463653A3.5040606@rtr.ca>
	<46367D7E.6060502@rtr.ca>
	<1177976798.12796.286.camel@imap.mvista.com>
	<463683A6.4010505@rtr.ca>
	<1178026458.5791.305.camel@localhost.localdomain>
	<4637419D.8010303@rtr.ca>
	<463741F1.7050706@rtr.ca>
	<1178027285.5791.307.camel@localhost.localdomain>
	<46374B1D.6050509@rtr.ca>
	<1178035058.5791.333.camel@localhost.localdomain>
	<46377055.2060605@rtr.ca>
	<1178092035.5791.349.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 09:47:15 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> Mark,
> 
> On Tue, 2007-05-01 at 12:52 -0400, Mark Lord wrote:
> > Done, and done.
> > And I managed to capture more of the boot messages, too.
> > This new capture is in the "sequence" subdir at the previous link.
> 
> thanks. Can you apply this patch please:
> http://lkml.org/lkml/2007/4/13/190
>
> It somehow did not make it into 2.6.21.
> 

Alas, poor me.  I ain't going to merge a contention-reduction patch when
we're at -rc6.  If a patch fixes a bug, please tell me!

