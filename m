Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYCHUbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYCHUbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 15:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYCHUbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 15:31:12 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:38284 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYCHUbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 15:31:11 -0500
Date: Sat, 8 Mar 2008 23:30:15 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] signals: print_fatal_signal: fix the signr "calculation"
Message-ID: <20080308203015.GC83@tv-sign.ru>
References: <20080308172453.GA28323@tv-sign.ru> <20080308190311.779B326F990@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308190311.779B326F990@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Roland McGrath wrote:
>
> Hmm.  I see that non-coredump signals that hit the optimized fatal case in
> __group_complete_signal will cause every thread to have a pending SIGKILL.
> So that will be seen first and prevent the print-out.  So that's what you
> intend to change?

Yes,

> I'm not sure print-fatal-signals was really ever intended for non-coredump
> signals.

Great, thanks! Please ignore this patch then. I was afraid something was
missed here.

Oleg.

