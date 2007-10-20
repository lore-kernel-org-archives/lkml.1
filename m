Return-Path: <linux-kernel-owner+w=401wt.eu-S936631AbXJTABg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936631AbXJTABg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 20:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765037AbXJTAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 20:01:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34314
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757494AbXJTAB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 20:01:27 -0400
Date: Fri, 19 Oct 2007 17:01:40 -0700 (PDT)
Message-Id: <20071019.170140.45897518.davem@davemloft.net>
To: cebbert@redhat.com
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.23] tasks stuck in running state?
From: David Miller <davem@davemloft.net>
In-Reply-To: <47192D20.8090608@redhat.com>
References: <47192763.9050004@redhat.com>
	<47192999.6010607@garzik.org>
	<47192D20.8090608@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>
Date: Fri, 19 Oct 2007 18:18:08 -0400

> On 10/19/2007 06:03 PM, Jeff Garzik wrote:
> >> [jgarzik@pretzel misc-2.6]$ strace -p8484
> >> Process 8484 attached - interrupt to quit
> > [sits there, chewing up CPU grepping a 47-line header file]
> > 
> 
> And sysrq-p is pretty useless unless you can force the keyboard
> interrupt and the spinning process onto the same CPU.

Yes, I find this a painful limitation too.

Sparc64 used to dump the registers on all active cpus for show_regs()
via a cross-call, and this was incredibly useful.  But I disabled that
as soon as I started playing with Niagara because at 32 cpus and
larger the output is just too voluminous to be useful.

What might be appropriate is just to get a one-line program counter
dump on every cpu via some new sysrq keystroke.
