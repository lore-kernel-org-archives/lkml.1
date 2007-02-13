Return-Path: <linux-kernel-owner+w=401wt.eu-S1751070AbXBMUmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbXBMUmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXBMUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:42:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37804 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbXBMUml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:42:41 -0500
Date: Tue, 13 Feb 2007 21:39:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213203952.GA18130@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <d120d5000702130746k1a110efcice6630827510e96c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000702130746k1a110efcice6630827510e96c@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4991]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > What are the semantics of async sys_async_wait and async sys_async ?
> 
> Ooooohh. OpenVMS lives forever ;) Me likeee ;)

hm, i dont know OpenVMS - but googled around a bit for 'VMS 
asynchronous' and it gave me this:

  http://en.wikipedia.org/wiki/Asynchronous_system_trap

is AST what you mean? From a quick read AST seems to be a signal 
mechanism a bit like Unix signals, extended to kernel-space as well - 
while syslets are a different 'safe execution engine' kind of thing 
centered around the execution of system calls.

	Ingo
