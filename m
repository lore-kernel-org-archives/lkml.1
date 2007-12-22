Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbXLVBwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbXLVBwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXLVBwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:52:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47507 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXLVBwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:52:17 -0500
Date: Sat, 22 Dec 2007 02:53:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, mtk.manpages@googlemail.com,
       akpm@linux-foundation.org, lkml@davidb.org, paulus@samba.org,
       drepper@redhat.com, cfriesen@nortel.com, schwab@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-ID: <20071222015311.GB4477@one.firstfloor.org>
References: <20071220.035104.240386115.davem@davemloft.net> <p73wsr7ef1h.fsf@bingen.suse.de> <20071221.174124.208826257.davem@davemloft.net> <20071221.174547.136433173.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221.174547.136433173.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And to handle potentially ambiguous cases we, for a long time, have
> the force_successful_syscall_return() arch hook. 

Ah I see what you mean now.

Thanks for the clarification.

Ok that could be in theory made to work yes. The migration would
probably be ugly though (how would glibc figure out if the kernel
does that or not?)

-Andi
