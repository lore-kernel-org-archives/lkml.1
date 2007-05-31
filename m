Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbXEaUKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbXEaUKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXEaUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:10:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbXEaUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:10:05 -0400
Date: Thu, 31 May 2007 22:09:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Dike <jdike@addtoit.com>
Cc: Zach Brown <zach.brown@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070531200949.GA10380@elte.hu>
References: <20070531181923.GA9904@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531181923.GA9904@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Dike <jdike@addtoit.com> wrote:

> cachemiss_thread should explicitly return 0 or error instead of 
> task_ret_reg(current) (which is -ENOSYS anyway) because 
> async_thread_helper is careful to put the return value in eax anyway.

oops, indeed! Thanks.

	Ingo
