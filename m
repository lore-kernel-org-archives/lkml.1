Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbYG2L3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbYG2L3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYG2L3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:29:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47194 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYG2L3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:29:43 -0400
Date: Tue, 29 Jul 2008 20:28:24 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: build failure
Cc: kosaki.motohiro@jp.fujitsu.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>, Mike Travis <travis@sgi.com>
In-Reply-To: <20080729085815.GA1301@elte.hu>
References: <20080729180317.94c64634.sfr@canb.auug.org.au> <20080729085815.GA1301@elte.hu>
Message-Id: <20080729202731.F18F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Ingo,
> > 
> > On Tue, 29 Jul 2008 10:00:55 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > > -#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
> > > > +#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
> > > 
> > > hm, i'm wondering - is this a compiler bug?
> > 
> > Or maybe a deficiency in such an old compiler (v3.4.5) but the fix 
> > makes sense anyway, right?
> 
> yeah, i was just wondering.

in linux/README

COMPILING the kernel:

 - Make sure you have at least gcc 3.2 available.
   For more information, refer to Documentation/Changes.



So, if 3.4.5 is old, Should we change readme?



