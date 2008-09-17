Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYIQTOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYIQTOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYIQTOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:14:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbYIQTOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:14:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
In-Reply-To: Frank Mayhar's message of  Wednesday, 17 September 2008 12:03:07 -0700 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	<20080914150651.GK12522@elte.hu>
	<20080914150923.GB26984@elte.hu>
	<1221502142.19012.35.camel@bobble.smo.corp.google.com>
	<20080916084143.GC17287@elte.hu>
	<1221678187.13420.17.camel@bobble.smo.corp.google.com>
X-Zippy-Says: I will invent "TIDY BOWL"...
Message-Id: <20080917191333.6FA7E640A5@pipsqueak.localdomain>
Date: Wed, 17 Sep 2008 12:13:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had been thinking not so much about code size, but about the unnecessary
indirection and allocation for the UP case.  I'm happy to defer to Ingo on
whether to worry about that.


Thanks,
Roland
