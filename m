Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbYKXFFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbYKXFFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbYKXFFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:05:35 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:52018 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYKXFFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:05:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 23 Nov 2008 21:05:33 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tejun Heo <htejun@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: poll: allow f_op->poll to sleep, take #3
In-Reply-To: <alpine.DEB.1.10.0811232054400.29950@alien.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0811232101330.29950@alien.or.mcafeemobile.com>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com>
 <20081123085902.GI30453@elte.hu> <49291F06.5040907@gmail.com> <20081123093420.GN30453@elte.hu> <492925B0.9030404@gmail.com> <20081123094551.GQ30453@elte.hu> <492A2DBF.3030208@gmail.com> <alpine.DEB.1.10.0811232054400.29950@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008, Davide Libenzi wrote:

> I was noticing that wake ups on the poll queues do not use sync=1, AFAICS.
> So using wake_up_state() and ignoring 'sync' should be fine. And 'key' is 
> already ignored by default by default_wake_function().

*cough*  wrong *cough* :) Pipes & more.


- Davide


