Return-Path: <linux-kernel-owner+w=401wt.eu-S1764630AbYHFJgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764630AbYHFJgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758393AbYHFJgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:36:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57676
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758216AbYHFJgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:36:37 -0400
Date: Wed, 06 Aug 2008 02:36:38 -0700 (PDT)
Message-Id: <20080806.023638.98202277.davem@davemloft.net>
To: jeff.chua.linux@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <b6a2187b0808060233t6bd437edi7e74fa225aaa9d01@mail.gmail.com>
References: <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
	<20080806.001836.135194365.davem@davemloft.net>
	<b6a2187b0808060233t6bd437edi7e74fa225aaa9d01@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeff Chua" <jeff.chua.linux@gmail.com>
Date: Wed, 6 Aug 2008 17:33:07 +0800

> On Wed, Aug 6, 2008 at 3:18 PM, David Miller <davem@davemloft.net> wrote:
> 
> > You have to turn off CONFIG_PROVE_LOCKING, in fact just turn off
> > everything in the lock debugging section:
> >
> > # CONFIG_DEBUG_RT_MUTEXES is not set
> > # CONFIG_RT_MUTEX_TESTER is not set
> > # CONFIG_DEBUG_SPINLOCK is not set
> > # CONFIG_DEBUG_MUTEXES is not set
> > # CONFIG_DEBUG_LOCK_ALLOC is not set
> > # CONFIG_PROVE_LOCKING is not set
> > # CONFIG_LOCK_STAT is not set
> > # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> > # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> >
> 
> I don't any option to turn these off. Still searching.

Maybe edit the ".config" file at the top level of the kernel
sources and then type "make oldconfig" ?!?!?!

