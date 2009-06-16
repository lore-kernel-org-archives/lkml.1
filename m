Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZFPI4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZFPI4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZFPIz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:55:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43124 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750942AbZFPIz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:55:57 -0400
Date: Tue, 16 Jun 2009 09:57:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616095706.36f01282@lxorguk.ukuu.org.uk>
In-Reply-To: <20090616085028.GA13771@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com>
	<20090616093741.0d5b36bc@lxorguk.ukuu.org.uk>
	<20090616085028.GA13771@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, have you tried the patch i sent to you that extends the 
> number-lock-locks-tracked limit you have run into? It is trivial.

I tried upping the number of locks a while ago - it has no effect, which
checking on irc seems to fit the general pattern of the reports against
Fedora.

The good thing is I trigger this at boot time reliably - so if you've got
some debug stuff you want to stick in I can do that


Alan
