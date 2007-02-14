Return-Path: <linux-kernel-owner+w=401wt.eu-S1750849AbXBNKzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849AbXBNKzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXBNKzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:55:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32926 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbXBNKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:55:36 -0500
Date: Wed, 14 Feb 2007 11:07:36 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
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
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
Message-ID: <20070214110736.35d83b2a@localhost.localdomain>
In-Reply-To: <20070213203952.GA18130@elte.hu>
References: <20060529212109.GA2058@elte.hu>
	<20070213142010.GA638@elte.hu>
	<20070213150019.4b4d4827@localhost.localdomain>
	<d120d5000702130746k1a110efcice6630827510e96c@mail.gmail.com>
	<20070213203952.GA18130@elte.hu>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ooooohh. OpenVMS lives forever ;) Me likeee ;)
> 
> hm, i dont know OpenVMS - but googled around a bit for 'VMS 
> asynchronous' and it gave me this:

VMS had SYS$QIO which is asynchronous I/O queueing with completions of
sorts. You had to specifically remember if you wanted to a synchronous
I/O.

Nothing afaik quite like series of commands batched async, although VMS
has a call for everything else so its possible there is one buried in the
back of volume 347 of the grey wall ;)

Looking at the completion side I'm not 100% sure we need async_wait given
the async batches can include futex operations...

Alan
