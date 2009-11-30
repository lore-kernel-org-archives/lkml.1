Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZK3J2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZK3J2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZK3J2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:28:32 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:43129 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752970AbZK3J2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:28:31 -0500
Date: Mon, 30 Nov 2009 10:28:28 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: dedekind1@gmail.com
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses and
 panics
Message-ID: <20091130102828.273b925d@marrow.netinsight.se>
In-Reply-To: <1259572187.7518.70.camel@localhost>
References: <20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	<20091012110954.67d7d8d8.akpm@linux-foundation.org>
	<20091012182346.GH17138@elte.hu>
	<alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	<20091013151751.59e217a7@marrow.netinsight.se>
	<20091013152235.188059d2@marrow.netinsight.se>
	<20091126093657.GA25430@logfs.org>
	<1259572187.7518.70.camel@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 11:09:47 +0200
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> > I believe this bit is wrong.  log_end is an unsigned int, so it can
> > wrap relatively quickly.  If log_end just wrapped to 0 and dump_kmsg is
> > called, the amount of printk buffer stored appears to be 0 as well.
> 
> Simon, if you want your patches to be merged to 2.6.33, we should
> address this issue ASAP, otherwise it'll be too late.

I'm testing your patch, I'll get back when I have verified that it works.

// Simon
