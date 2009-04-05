Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZDEQtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZDEQtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 12:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZDEQtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 12:49:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41125 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZDEQtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 12:49:06 -0400
Date: Sun, 5 Apr 2009 09:49:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dipankar@in.ibm.com, niv@us.ibm.com, manfred@colorfullife.com,
       peterz@infradead.org, lethal@linux-sh.org, kernel@wantstofly.org,
       kyle@mcmartin.ca, deller@gmx.de, davem@davemloft.net,
       ralf@linux-mips.org, jes@sgi.com, benh@kernel.crashing.org,
       paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to
	TREE_RCU.
Message-ID: <20090405164904.GJ6893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3181463559098978317@unknownmsgid> <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com> <20090404163149.GC6893@linux.vnet.ibm.com> <20090405101756.GA10490@elte.hu> <20090405103759.GA17934@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090405103759.GA17934@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 12:37:59PM +0200, Andi Kleen wrote:
> > I'd suggest you dont do these dozens of defconfig updates at all - 
> > arch maintainers can do this themselves, once the core kernel 
> > default has been flipped.
> 
> AFAIK they don't. There's no make updatemyconfigwithdefaultstatementsconfig

My guess is that I would in fact have to send a few patches.  But I
suppose that the real question is "how long should we wait to drop
Classic RCU once the last arch has changed its defconfig?"  I have
been assuming that we would wait one release cycle.

							Thanx, Paul
