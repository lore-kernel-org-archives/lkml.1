Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZKQIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZKQIzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZKQIzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:55:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:40002 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZKQIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:55:37 -0500
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michel Lespinasse <walken@google.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20091117081817.GA7963@elte.hu>
References: <20091117074655.GA14023@google.com>
	 <20091117081817.GA7963@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 09:55:21 +0100
Message-ID: <1258448121.7816.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 09:18 +0100, Ingo Molnar wrote:
> 
> Would you be interested in adding it as a 'perf bench futex' testcase? 
> That way kernel developers could monitor futex performance in the future 
> as well.
> 
> See 'perf bench' in the latest perf events tree:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> Do 'cd tools/perf; make -j install' to install perf.

Darren has recently been putting a lot of effort in making a futex test
suite:

http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git

Its not yet complete, but hopefully it will soon be :-)

