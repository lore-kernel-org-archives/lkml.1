Return-Path: <linux-kernel-owner+w=401wt.eu-S1765450AbYDYUTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765450AbYDYUTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764507AbYDYUSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:18:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59662
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764355AbYDYUSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:18:24 -0400
Date: Fri, 25 Apr 2008 13:18:23 -0700 (PDT)
Message-Id: <20080425.131823.109945389.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jirislaby@gmail.com, zdenek.kabelac@gmail.com, rjw@sisk.pl,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, andi@firstfloor.org, pageexec@freemail.hu,
       hpa@zytor.com, jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/1] x86: fix text_poke
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
References: <20080425.021301.193689806.davem@davemloft.net>
	<1209343883-7991-1-git-send-email-jirislaby@gmail.com>
	<alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2008 08:03:27 -0700 (PDT)

> On Mon, 28 Apr 2008, Jiri Slaby wrote:
> > 
> > Thanks. Bisected mm down to git-x86.patch, bisected git-x86-latest down to
> > x86: enhance DEBUG_RODATA support - alternatives
> > The patch below fixes the problem for me. Comments welcome.
> 
> You're a hero, Jiri.

Indeed, what a heroic effort to fix a bug, thanks Jiri!!
