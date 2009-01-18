Return-Path: <linux-kernel-owner+w=401wt.eu-S1765415AbZARNRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765415AbZARNRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 08:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbZARNRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 08:17:14 -0500
Received: from netgear.net.ru ([195.178.208.66]:47759 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756028AbZARNRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 08:17:14 -0500
Date: Sun, 18 Jan 2009 16:17:15 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090118131715.GB19292@ioremap.net>
References: <bTNi6-3kb-9@gated-at.bofh.it> <bTOea-4QT-1@gated-at.bofh.it> <bTQ6f-7Qs-1@gated-at.bofh.it> <bTQpv-5o-3@gated-at.bofh.it> <bTQzd-iK-5@gated-at.bofh.it> <bTXhp-2IA-31@gated-at.bofh.it> <bTZjb-62D-25@gated-at.bofh.it> <E1LOCze-00020X-GT@be1.7eggert.dyndns.org> <20090117154147.GA12863@ioremap.net> <alpine.LSU.0.999.0901181337430.6179@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0901181337430.6179@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 01:49:58PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> > OOM scores can not be reliably tuned system-wide.
> 
> As I said, if a program starts misbehaving, it's mostly not sane to keep
> it alive. Besides that, the oom_adj allows you to special case some
> processes to be immortal or to be kenny, but you should be prepared for 
> trouble then.

oom_adj can turn off the oom-killer for given PID and make it
essentially immortal, it practically can not faingrainely tune this.
But even than can only be achieved with lots of problems, that's the
main point of the patch: to make things simple for the people who know
what they are doing.

-- 
	Evgeniy Polyakov
