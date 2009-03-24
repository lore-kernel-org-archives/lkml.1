Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZCXJb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZCXJb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZCXJbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:31:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbZCXJbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:31:16 -0400
Date: Tue, 24 Mar 2009 10:31:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
Message-ID: <20090324093103.GA19463@elte.hu>
References: <1237884230.25315.33.camel@penberg-laptop> <20090324085128.GF13016@elte.hu> <1237884846.25315.37.camel@penberg-laptop> <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop> <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop> <20090324091742.GB6605@elte.hu> <1237886559.25315.60.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1237886559.25315.60.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 2009-03-24 at 10:17 +0100, Ingo Molnar wrote:
> > > OK, I think all of them are now fixed. I haven't yet been able to 
> > > complete a build so help is still appreciated. ;-)
> > 
> > unless there's a mail delay, we still have:
> > 
> > lib/decompress_unlzma.c:122: error: implicit declaration of function ‘kfree’
> > lib/decompress_unlzma.c:551: error: implicit declaration of function ‘kmalloc’
> 
> Sorry, I missed that. I was testing the .config you sent in the 
> initial mail, not allyesconfig. I sent you a patch to fix that as 
> well now.

no problem, i missed it too - computer reminded us that it's still 
there ;-)

there's a new headers-export-check failure:

/home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
make[2]: *** [linux] Error 2

(CONFIG_HEADERS_CHECK)

	Ingo
