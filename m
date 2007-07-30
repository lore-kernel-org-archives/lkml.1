Return-Path: <linux-kernel-owner+w=401wt.eu-S936910AbXG3JTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936910AbXG3JTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbXG3JTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:19:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33350 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXG3JTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:19:16 -0400
Date: Mon, 30 Jul 2007 15:01:28 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070730085331.GF9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707301452380.13448@enigma.security.iitk.ac.in>
References: <1185288769.14697.339.camel@pmac.infradead.org>
 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
 <20070729100007.GB9840@enneenne.com> <alpine.LFD.0.999.0707301034240.10861@enigma.security.iitk.ac.in>
 <20070730085331.GF9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,


On Mon, 30 Jul 2007, Rodolfo Giometti wrote:

> On Mon, Jul 30, 2007 at 10:39:38AM +0530, Satyam Sharma wrote:
> > 
> > Nopes, this isn't quite correct/safe. I suggest you should read:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/
> 
> I read it but still I don't see why my solution isn't correct/safe. :)

What does the section on locking between hard irq contexts (or between
user process context and hard irq context) say?

> Can you please propose to me your solution?

As I said, you could just use the spin_lock_irqsave/restore() variants ...
If you want, I can try and implement the other bits that I had suggested
for the other things as well :-)


Ciao,
Satyam
