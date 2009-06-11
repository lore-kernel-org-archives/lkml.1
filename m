Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbZFKWjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbZFKWjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbZFKWjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:39:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41020 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756462AbZFKWjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:39:05 -0400
Date: Thu, 11 Jun 2009 23:38:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611233803.4876b1fb@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain>
References: <20090611165226.GV8633@ZenIV.linux.org.uk>
	<1244739378.6691.540.camel@laptop>
	<20090611170015.GA3651@infradead.org>
	<alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
	<33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
	<alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
	<20090611202341.GA23590@elte.hu>
	<1244753357.27363.82.camel@violet>
	<20090611210810.GA9317@uranus.ravnborg.org>
	<1244755036.27363.93.camel@violet>
	<20090611212635.GA9446@uranus.ravnborg.org>
	<4A3182C6.803@gmail.com>
	<alpine.LFD.2.01.0906111521210.3535@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Look at how many git binary packages there are some day. For CVS users, 
> for SVN people, graphical tools etc. Do you think that each of them has a 
> source package?

That misses the point, at least for the systems as the work now. Having a
single source package to multiple binaries is easy. Managing setups where
you push only some of those binaries into the system gets really ugly.

A pile of git-foo packages works because you almost never push a fix to
one tool alone, and if you do its small enough not to be a big deal.

