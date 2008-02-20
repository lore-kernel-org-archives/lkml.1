Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbYBTSyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbYBTSyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYBTSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:54:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYBTSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:54:07 -0500
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080220103940.0a0b5ce0@laptopd505.fenrus.org>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <1203531375.6243.52.camel@lappy>
	 <20080220103940.0a0b5ce0@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 19:53:42 +0100
Message-Id: <1203533622.6243.55.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 10:39 -0800, Arjan van de Ven wrote:
> On Wed, 20 Feb 2008 19:16:15 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > 
> > On Tue, 2008-02-19 at 12:37 -0800, Arjan van de Ven wrote:
> > > From: Soren Sandmann <sandmann@redhat.com>
> > > Subject: [PATCH] x86: add the debugfs interface for the sysprof tool
> > > 
> > > The sysprof tool is a very easy to use GUI tool to find out where
> > > userspace is spending CPU time. See
> > > http://www.daimi.au.dk/~sandmann/sysprof/
> > > for more information and screenshots on this tool.
> > > 
> > > Sysprof needs a 200 line kernel module to do it's work, this
> > > module puts some simple profiling data into debugfs.
> > 
> > What is the added value over oprofile?
> 
> it actually works and is usable by humans ;)

# sysprof

(sysprof:12480): Gtk-WARNING **: cannot open display:

-ENOX

> what oprofile doesn't do is the nice userland hierarchy of where cpu time is spend.
> (and that is also what makes it mostly useless in practice)

so why not fix oprofile callgraph output and build a GUI on top of
oprofile for those of us who really want RSI from mouse movement :-)

