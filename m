Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbYBTS6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbYBTS6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbYBTS62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:58:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48335 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758989AbYBTS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:58:26 -0500
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
In-Reply-To: <1203533622.6243.55.camel@lappy>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <1203531375.6243.52.camel@lappy>
	 <20080220103940.0a0b5ce0@laptopd505.fenrus.org>
	 <1203533622.6243.55.camel@lappy>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 19:58:05 +0100
Message-Id: <1203533885.6243.60.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 19:53 +0100, Peter Zijlstra wrote:
> On Wed, 2008-02-20 at 10:39 -0800, Arjan van de Ven wrote:
> > On Wed, 20 Feb 2008 19:16:15 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > 
> > > On Tue, 2008-02-19 at 12:37 -0800, Arjan van de Ven wrote:
> > > > From: Soren Sandmann <sandmann@redhat.com>
> > > > Subject: [PATCH] x86: add the debugfs interface for the sysprof tool
> > > > 
> > > > The sysprof tool is a very easy to use GUI tool to find out where
> > > > userspace is spending CPU time. See
> > > > http://www.daimi.au.dk/~sandmann/sysprof/
> > > > for more information and screenshots on this tool.
> > > > 
> > > > Sysprof needs a 200 line kernel module to do it's work, this
> > > > module puts some simple profiling data into debugfs.
> > > 
> > > What is the added value over oprofile?
> > 
> > it actually works and is usable by humans ;)
> 
> # sysprof
> 
> (sysprof:12480): Gtk-WARNING **: cannot open display:
> 
> -ENOX

Usable for me is a cli interface. Also, I absolutely love opannotate.

For a fact, most of my professional userspace development days, I had to
profile on remote machines with no X.

