Return-Path: <linux-kernel-owner+w=401wt.eu-S934619AbXEMQi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbXEMQi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXEMQiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:38:17 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48979 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbXEMQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:38:16 -0400
X-Originating-Ip: 72.143.66.196
Date: Sun, 13 May 2007 12:37:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
In-Reply-To: <1179073670.3723.48.camel@mulgrave.il.steeleye.com>
Message-ID: <Pine.LNX.4.64.0705131237190.924@localhost.localdomain>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain> 
 <20070513160608.GA29024@redhat.com>  <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
  <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
 <1179073670.3723.48.camel@mulgrave.il.steeleye.com>
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

On Sun, 13 May 2007, James Bottomley wrote:

> On Sun, 2007-05-13 at 12:20 -0400, Robert P. J. Day wrote:
> > since this thread looks like it's going to get away from me in a
> > hurry :-), my only point in asking was to point out that that lone
> > module was the only thing preventing the build from being module-free.
> >
> > i'm not saying that that's *necessarily* a good thing, but it just
> > strikes me as odd that, out of all of the possible modules that might
> > be selected in a default config for x86, this was the *only* one that
> > was picked.
> >
> > i just think it's a bit weird, that's all.
>
> It's designed on the predicate that people who want to be module free
> will actually set CONFIG_MODULE=n.
>
> If you set CONFIG_MODULE=y and build SCSI we assume you could have a
> SCSI driver module at some point, which would necessitate the wait scan
> module.

ok, fair enough.  thanks.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
