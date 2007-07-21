Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXGUWXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXGUWXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXGUWWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:22:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55093 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbXGUWWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:22:52 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 21 Jul 2007 18:15:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, kbuild-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [kbuild-devel] [PATCH 25/33] kbuild: use POSIX BRE in headers
 install target
In-Reply-To: <8bd0f97a0707211512t46db7eedid21c759613d06a75@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707211814560.17020@localhost.localdomain>
References: <11846813442810-git-send-email-sam@ravnborg.org>
 <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org>
 <E1ICAEU-0005an-5F@flower> <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com>
 <20070721100422.GK475@flower.upol.cz> <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com>
 <20070721203916.GA2912@uranus.ravnborg.org> <8bd0f97a0707211503y3de01d30n9b283237103fbc4@mail.gmail.com>
 <20070721221142.GB2912@uranus.ravnborg.org>
 <8bd0f97a0707211512t46db7eedid21c759613d06a75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.646, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_NL 0.08, TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Mike Frysinger wrote:

> On 7/21/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Sat, Jul 21, 2007 at 06:03:00PM -0400, Mike Frysinger wrote:
> > > On 7/21/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > > >I would much more prefer this functionality to be integrated into unifdef.
> > > >There is no good reason to have two different preprocesisng methonds, one
> > > >being the sed based one and the other the unidef one.
> > > >
> > > >A sinlge dedicated program that contian the sum of the functionality would
> > > >be faster too.
> > >
> > > which functionality ?  normalizing of whitespace or all these
> > > linux-specific hacks ?  unifdef serves one specific function which is
> > > stated in its manpage: remove preprocessor conditionals from code.
> >
> > At present the kernel has a private copy of unidef. So adjusting the
> > private copy for the needs of the kernels seems like a god plan.
>
> didnt realize the kernel had integrated it since it didnt at first ...
> so yeah, extending it however we see fit should be fine
> -mike

just for the entertainment value:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=217840

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
