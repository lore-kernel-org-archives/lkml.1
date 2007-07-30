Return-Path: <linux-kernel-owner+w=401wt.eu-S968451AbXG3TSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968451AbXG3TSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967357AbXG3TSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:18:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967392AbXG3TSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:18:33 -0400
Date: Mon, 30 Jul 2007 21:18:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [bug] pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
Message-ID: <20070730191815.GA30889@elte.hu>
References: <20070722124224.GA20382@elte.hu> <a781481a0707220753q2754f3cfy47941405f92c833d@mail.gmail.com> <20070723093302.2a2bf9d4@gondolin.boeblingen.de.ibm.com> <20070729190615.GA28995@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729190615.GA28995@infomag.infomag.iguana.be>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Wim Van Sebroeck <wim@iguana.be> wrote:

> See below fix. Please test it.

thanks, this fixes the crash!

Michal, please mark this .23 regression entry as resolved:

 Subject         : pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
 References      : http://lkml.org/lkml/2007/7/22/94
 Last known good : ?
 Submitter       : Ingo Molnar <mingo@elte.hu>
 Caused-By       : ?
 Handled-By      : Wim Van Sebroeck <wim@iguana.be>
 Patch           : http://lkml.org/lkml/2007/7/29/235
 Status          : patch available

> [WATCHDOG] Fix pcwd_init_module crash

> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
