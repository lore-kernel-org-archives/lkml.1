Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZFNJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZFNJiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZFNJiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:38:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37097 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZFNJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:38:09 -0400
Date: Sun, 14 Jun 2009 18:37:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: akpm <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open when supported
Message-ID: <20090614093725.GD832@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	akpm <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> <8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 06:48:52AM -0400, Mike Frysinger wrote:
> On Fri, Jun 12, 2009 at 07:29, Mike Frysinger wrote:
> > If the port does not support HAVE_PERF_COUNTERS, then they can't support
> > the perf_counter_open syscall either. ??Rather than forcing everyone to add
> > an ignore (or suffer the warning until they get around to implementing
> > support), only whine about the syscall when applicable.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Andrew: could you pick this up since Ingo acked it now ?

I fail to see why this is necessary? cond_syscall() takes care of this in
the not implemented case, the same as every other syscall backing some
feature that has yet to be implemented.
