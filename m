Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZFXHDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZFXHDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZFXHDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:03:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZFXHDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:03:16 -0400
Date: Wed, 24 Jun 2009 09:03:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
Message-ID: <20090624070315.GH6760@one.firstfloor.org>
References: <20090622.002722.53993293.davem@davemloft.net> <87bpog3clx.fsf@basil.nowhere.org> <20090622.022752.219499742.davem@davemloft.net> <20090623.171735.154729801.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623.171735.154729801.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not exactly sure what to do about this.

Ack the timer interrupt earlier (and also give it a high priority?)

That could be still problematic if you have non nestabled irq stacks
(haven't checked if sparc has that or not), 
potentially you might need to run the softirq on the process stack.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
