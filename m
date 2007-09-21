Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbXIUUH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbXIUUH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbXIUUHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:07:51 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51456 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbXIUUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:07:50 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 21 Sep 2007 16:06:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       andrea@suse.de, clameter@sgi.com
Subject: Re: + oom-move-prototypes-to-appropriate-header-file.patch added to
 -mm tree
In-Reply-To: <20070921195403.GC1857@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0709211605340.19300@localhost.localdomain>
References: <200709210910.l8L9AttS028186@imap1.linux-foundation.org>
 <20070921170548.GA1857@martell.zuzino.mipt.ru>
 <alpine.DEB.0.9999.0709211236130.29079@chino.kir.corp.google.com>
 <20070921195403.GC1857@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Alexey Dobriyan wrote:

> On Fri, Sep 21, 2007 at 12:38:03PM -0700, David Rientjes wrote:
> > On Fri, 21 Sep 2007, Alexey Dobriyan wrote:
> >
> > > > Move the OOM killer's extern function prototypes to include/linux/oom.h and
> > > > include it where necessary.
> > > >
> > > > Cc: Andrea Arcangeli <andrea@suse.de>
> > > > Acked-by: Christoph Lameter <clameter@sgi.com>
> > >
> > > NAK. Target in corresponding Kbuild is wrong. sched.h is overkill.
> > > Could we please also drop extern's while in protos?
> > >
> >
> > I'll prevent including sched.h in a follow-up patchset that I'll be
> > posting soon (and you'll be Cc'd).  Which Kbuild target are you referring
> > to?
>
> It's header-y vs unifdef-y in include/linux/Kbuild. The former is
> for plain headers exported to userspace as-is. The latter need
> preprocessing to remove __KERNEL__, CONFIG_*, etc.

AFAIK, the only preprocessing that's removed is "__KERNEL__".

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
