Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbXH1JLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbXH1JLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbXH1JLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:11:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbXH1JLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:11:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
In-Reply-To: Andrew Morton's message of  Monday, 30 July 2007 16:35:38 -0700 <20070730163538.67b256da.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Emacs: the road to Hell is paved with extensibility.
Message-Id: <20070828091109.9E4E14D04CC@magilla.localdomain>
Date: Tue, 28 Aug 2007 02:11:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In POSIX, select/pselect is specifically exempted from the usual SA_RESTART
behavior.  I'm not really sure if that is entirely historical or because
after a handler has run even an adjusted relative timeout may no longer be
what you actually want.  There is no such exemption for poll/ppoll, though
in general their behavior and specification are very parallel.  I wonder if
they really should diverge.


Thanks,
Roland
