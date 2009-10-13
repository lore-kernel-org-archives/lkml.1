Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbZJMJAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbZJMJAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZJMJAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:00:45 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18520 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZJMJAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:00:44 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091013095805.477f1928@marrow.netinsight.se>
References: <20091012113758.GB11035@elte.hu>
	 <20091012140149.6789efab@marrow.netinsight.se>
	 <20091012120951.GA16799@elte.hu>
	 <1255349748.10605.13.camel@macbook.infradead.org>
	 <20091012122023.GA19365@elte.hu>
	 <20091012150650.51a4b4dc@marrow.netinsight.se>
	 <20091012131528.GC25464@elte.hu>
	 <20091012153937.0dcd73e5@marrow.netinsight.se>
	 <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	 <20091012110954.67d7d8d8.akpm@linux-foundation.org>
	 <20091012182346.GH17138@elte.hu>
	 <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	 <20091013095805.477f1928@marrow.netinsight.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 11:57:01 +0300
Message-Id: <1255424221.32489.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Oct 2009 08:57:07.0590 (UTC) FILETIME=[2485FA60:01CA4BE3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 09:58 +0200, Simon Kagstrom wrote:
> On Mon, 12 Oct 2009 11:45:15 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So the logic should literally be something like this:
> > 
> >  - kernel/printk.c:
> > 
> > 	void dump_kmsg(void)
> > 	{
> > 		unsigned long len = ACCESS_ONCE(log_end);
> 
> OK, I'll get back with a few patches that does this later today.

Yeah, I think it is good idea to work on a generic support, and simplify
mtdoops.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

