Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbXGQPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbXGQPrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935044AbXGQPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:45:14 -0400
Received: from mail.screens.ru ([213.234.233.54]:56057 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935033AbXGQPpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:45:12 -0400
Date: Tue, 17 Jul 2007 19:46:38 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chuck Ebbert <76306.1226@compuserve.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: a bogus set_fs(USER_DS) in setup_frame/setup_rt_frame ?
Message-ID: <20070717154638.GA342@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am really puzzled by set_fs(USER_DS) in setup_frame/setup_rt_frame.

How is it possible that current->addr_limit != USER_DS ? If this _is_
possible, how can can we trust the result of access_ok() above?

Thanks in advance,

Oleg.

