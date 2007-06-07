Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbXFGJyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbXFGJyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXFGJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:54:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXFGJyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:54:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] 2.6.22-rc4: wait4() waiting for SIGSTOP may not return if the target process is ptraced
In-Reply-To: Satoru Takeuchi's message of  Thursday, 7 June 2007 18:42:52 +0900 <87vee09k2r.wl%takeuchi_satoru@jp.fujitsu.com>
X-Shopping-List: (1) Intelligent battalion perversions
   (2) Concomitant swindlers
   (3) Pulmonary laxative sleeves
   (4) Hypothetical suspicious concussion dividers
   (5) Skid-proof turkeys
Message-Id: <20070607095432.559744D0597@magilla.localdomain>
Date: Thu,  7 Jun 2007 02:54:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is in strace (and is being fixed).  It needs to use tgkill instead
of kill to send that SIGSTOP to the right thread only.  


Thanks,
Roland
