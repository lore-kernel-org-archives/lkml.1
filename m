Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbXHRX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbXHRX3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 19:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbXHRX2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 19:28:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759187AbXHRX2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 19:28:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] exec: kill unsafe BUG_ON(sig->count) checks
In-Reply-To: Oleg Nesterov's message of  Saturday, 18 August 2007 21:39:36 +0400 <20070818173936.GA206@tv-sign.ru>
Emacs: it's like swatting a fly with a supernova.
Message-Id: <20070818232747.C0F9C4D05C6@magilla.localdomain>
Date: Sat, 18 Aug 2007 16:27:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Those BUG_ON's were there because of past bugs and fragility in the
de_thread and exit synchronization stuff.  There's no real need to leave
them (in fixed form) if we are confident of that stuff working right now,
or have other assertions to give us that confidence when we change it.


Thanks,
Roland
