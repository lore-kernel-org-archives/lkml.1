Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXJLMl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXJLMl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXJLMlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:41:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41373 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbXJLMlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:41:17 -0400
X-Originating-Ip: 99.236.101.138
Date: Fri, 12 Oct 2007 08:37:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the rationale for "TAINT_USER"?
In-Reply-To: <20071012122719.GB30350@atjola.homenet>
Message-ID: <Pine.LNX.4.64.0710120832350.22555@localhost.localdomain>
References: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
 <20071012122719.GB30350@atjola.homenet>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2046103468-1192192624=:22555"
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2046103468-1192192624=:22555
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 12 Oct 2007, Björn Steinbrink wrote:

> On 2007.10.12 08:04:20 -0400, Robert P. J. Day wrote:
> >
> >   i can see what the theoretical purpose for it is here:
> >
> > http://kerneltrap.org/node/6656
> >
> > but it's not clear how it can possibly be set from userland given
> > that:
> >
> > $ grep -r TAINT_USER *
> > include/linux/kernel.h:#define TAINT_USER                       (1<<6)
> > kernel/panic.c:                 tainted & TAINT_USER ? 'U' : ' ',
> > $
> >
> >   am i missing something screamingly obvious?
>
> Grepping for "tainted" leads me to:
>
> echo 32 > /proc/sys/kernel/tainted

???.  i have no idea what you were grepping through to find that
phrase, but TAINT_USER would seem to be equivalent to echo 64, not
echo 32, anyway, no?

in any event, as i posted in a followup, i'm assuming that that
particular bit is meant to be set explicitly from user space using
something like:

  # echo 64 > /proc/sys/kernel/tainted

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
--8323328-2046103468-1192192624=:22555--
