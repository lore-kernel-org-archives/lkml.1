Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbYFNKjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbYFNKjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYFNKiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:38:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55917
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754728AbYFNKii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:38:38 -0400
Date: Sat, 14 Jun 2008 03:38:38 -0700 (PDT)
Message-Id: <20080614.033838.207353824.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080614081656.GA27820@elte.hu>
References: <20080614062758.GA23803@elte.hu>
	<20080614.001428.26649070.davem@davemloft.net>
	<20080614081656.GA27820@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 14 Jun 2008 10:16:56 +0200

> * David Miller <davem@davemloft.net> wrote:
> 
> > This warning was added by Arjan in 2.6.25 FYI in order to diagnose the 
> > not-normal cases better.
> 
> ok, should we then remove that warning, if it's spurious? kerneloops.org 
> has picked up a few other instances of this warning as well:
> 
>   http://www.kerneloops.org/searchfile.php?search=net%2Fsched%2Fsch_generic.c&btnG=Filename+Search

Sorry, I misphrased that.

It always has warned.

The change is that it also now gives a stack backtrace.
