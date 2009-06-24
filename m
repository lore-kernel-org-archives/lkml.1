Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZFXKXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZFXKXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZFXKXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:23:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56896 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFXKXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:23:23 -0400
Date: Wed, 24 Jun 2009 12:23:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
Message-ID: <20090624102325.GN6760@one.firstfloor.org>
References: <20090624071555.GK6760@one.firstfloor.org> <20090624.001729.155964457.davem@davemloft.net> <20090624075342.GL6760@one.firstfloor.org> <20090624.024428.215194313.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624.024428.215194313.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And similarly to sparc64, if that 5+ second qla2xxx interrupt
> sequence happens after the tick_nohz_stop_sched_tick() call
> we can run into the same situation.

Yes it would be probably safer to do the tick disabling with interrupts off
already.

These days NMI watchdog is not used much on x86 anymore because it's 
default off, so probably people never noticed that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
