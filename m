Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYCKSHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYCKSHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYCKSHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:07:09 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51218 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYCKSHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:07:08 -0400
Date: Tue, 11 Mar 2008 21:11:27 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] signals: unify send_sigqueue/send_group_sigqueue completely
Message-ID: <20080311181127.GC586@tv-sign.ru>
References: <20080308151025.GA25191@tv-sign.ru> <20080311020759.B550126F991@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311020759.B550126F991@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Roland McGrath wrote:
>
> Looks fine.  But I'd like a comment on the "ret = 1" case making
> explicit what that magic return case is for and why the value
> matters (to posix_timer_event).

Well, currently this helper is solely used by posix_timer_event(), but despite
the fact it has BUG_ON(!SI_TIMER) it is quite generic, there were patches which
used it for aio.

So I don't think we should document the interaction with posix timers, but OK,
I'll send a small comment update.

Oleg.

