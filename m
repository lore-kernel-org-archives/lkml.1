Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXHISKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXHISKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXHISKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:10:21 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57822 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbXHISKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:10:18 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 9 Aug 2007 14:04:45 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Chris Snook <csnook@redhat.com>
cc: Jerry Jiang <wjiang@resilience.com>, Chris Friesen <cfriesen@nortel.com>,
       Zan Lynx <zlynx@acm.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
In-Reply-To: <Pine.LNX.4.64.0708091359180.25299@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708091404250.25868@localhost.localdomain>
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
 <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com>
 <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com>
 <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com>
 <46B8E64E.7010708@nortel.com> <1186525977.232321.43.camel@localhost>
 <46B91D0C.5050704@redhat.com> <46B94B94.6000600@nortel.com>
 <46B96719.3050006@redhat.com> <20070808162755.61f50fbf.wjiang@resilience.com>
 <46BA2D72.9060202@redhat.com> <Pine.LNX.4.64.0708090836070.10666@localhost.localdomain>
 <46BB0E1F.2030003@redhat.com> <Pine.LNX.4.64.0708091359180.25299@localhost.localdomain>
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

On Thu, 9 Aug 2007, Robert P. J. Day wrote:

> On Thu, 9 Aug 2007, Chris Snook wrote:
>
> > Robert P. J. Day wrote:
>
> > > i'm almost scared to ask any more questions.  :-)
> > >
> > > rday
> >
> > Momentarily I'll be posting a patchset that makes all atomic_t and
> > atomic64_t declarations non-volatile, and casts them to volatile
> > inside of atomic[64]_read.  This will ensure consistent behavior
> > across all architectures, and is in keeping with the philosophy that
> > memory reads should be enforced in running code, not declarations.
> >
> > I hope you don't mind that we're mooting the question by making the
> > code more sensible.
>
> not at all, but it does bring up the obvious next question -- once all
> these definitions are made consistent, is there any reason some of
> that content can't be centralized in a single atomic.h header file,
> rather than duplicating it across a couple dozen architectures?
>
> surely, after this process, there's going to be some content that's
> identical across all arches, no?
>
> rday

whoops, never mind, i just saw that earlier posting on this very
subject.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
