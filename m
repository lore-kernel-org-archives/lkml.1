Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbXGPLK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbXGPLK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXGPLKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:10:15 -0400
Received: from mail001.aei.ca ([206.123.6.130]:41558 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697AbXGPLKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:10:13 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v19
Date: Mon, 16 Jul 2007 11:10:08 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070706173319.GA2356@elte.hu> <200707141319.13270.edt@aei.ca> <20070716091737.GB5964@elte.hu>
In-Reply-To: <20070716091737.GB5964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707160710.09854.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 05:17, Ingo Molnar wrote:
> 
> * Ed Tomlinson <edt@aei.ca> wrote:
> 
> > I run a java application at nice 15.  Its been a background 
> > application here for as long as SD and CFS have been around.  If I 
> > have a compile running at nice 0, with v19 java gets so little cpu 
> > that the the wrapper that runs to monitor it is timing out waiting for 
> > it to start.  This is new in v19 - something in v19 is not meshing 
> > well with my mix of applications...
> 
> how much longer did the startup of the java app get relative to say v18?
> 
> to debug this, could you check whether this problem goes away if you use 
> nice 10 (or nice 5) instead of nice 15?

Ingo,

It may take a day to two before I get to test this. I have had to revert to 2.6.21 -
it seems that 22 triggers a stall here (21 also can trigger this but its harder)...

Thanks
Ed

