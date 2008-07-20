Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYGTMXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYGTMXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbYGTMXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:23:14 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49329 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbYGTMXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:23:12 -0400
Date: Sun, 20 Jul 2008 16:26:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer signal
Message-ID: <20080720122648.GE143@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com> <20080716162131.GA1785@tv-sign.ru> <1216292911.28332.12.camel@muff> <20080717135556.GA770@tv-sign.ru> <1216377558.12300.13.camel@muff> <20080719163734.GA389@tv-sign.ru> <20080720065240.B3D3715421D@magilla.localdomain> <20080720110856.GC143@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720110856.GC143@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20, Oleg Nesterov wrote:
>
> Suppose that the signal was already dequeued but sigq->info wasn't copied
> to the user-space.

To avoid a possible confusion: this is of course fine by itself, the content
of sigq->info was already copied to the local siginfo.

Oleg.

