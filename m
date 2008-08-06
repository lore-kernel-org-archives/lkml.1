Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYHFHSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYHFHSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 03:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYHFHSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 03:18:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45114
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754868AbYHFHSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 03:18:35 -0400
Date: Wed, 06 Aug 2008 00:18:36 -0700 (PDT)
Message-Id: <20080806.001836.135194365.davem@davemloft.net>
To: jeff.chua.linux@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	<20080805.221917.42858161.davem@davemloft.net>
	<b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeff Chua" <jeff.chua.linux@gmail.com>
Date: Wed, 6 Aug 2008 14:42:11 +0800

> On Wed, Aug 6, 2008 at 1:19 PM, David Miller <davem@davemloft.net> wrote:
> > From: "Jeff Chua" <jeff.chua.linux@gmail.com>
> > Date: Wed, 6 Aug 2008 11:15:30 +0800
> > Do you have lockdep enabled?  If sure, try turning that off.
> 
> It's enabled by default, and I can't seem to disable it even if I
> commented it out or delete it, it comes back after running "make".

You have to turn off CONFIG_PROVE_LOCKING, in fact just turn off
everything in the lock debugging section:

# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
