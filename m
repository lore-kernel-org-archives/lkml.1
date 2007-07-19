Return-Path: <linux-kernel-owner+w=401wt.eu-S939258AbXGSP3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939258AbXGSP3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXGSP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:29:21 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56626 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbXGSP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:29:20 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 11:27:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Karel Zak <kzak@redhat.com>, Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] Delete export of tty.h to userspace.
In-Reply-To: <20070719135707.GA16279@infradead.org>
Message-ID: <Pine.LNX.4.64.0707191126100.6804@localhost.localdomain>
References: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain>
 <469E7599.4060608@gmail.com> <Pine.LNX.4.64.0707181631340.14452@localhost.localdomain>
 <20070718223820.GF3181@petra.dvoda.cz> <Pine.LNX.4.64.0707190715320.25024@localhost.localdomain>
 <20070719135707.GA16279@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Christoph Hellwig wrote:

> On Thu, Jul 19, 2007 at 07:17:07AM -0400, Robert P. J. Day wrote:
> > so you're saying you'll drop that include from util-linux, is that
> > it? but it's still a good plan to generate a warning whenever
> > userspace includes that file, so i'll submit a quick patch to
> > generate that, based on jiri's suggestion.
>
> Not exporting it at all gives an error which is a lot better.  Just
> look at all the warnings most userspace spews, they'd never even
> notice it otherwise.

i'm fine either way, i just didn't want to gratuitously break
userspace.  someone higher up the food chain is welcome to make the
decision here.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
