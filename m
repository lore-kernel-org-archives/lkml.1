Return-Path: <linux-kernel-owner+w=401wt.eu-S1751248AbXJNEFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbXJNEFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXJNEEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:04:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXJNEEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:04:39 -0400
Date: Sun, 14 Oct 2007 06:04:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: gregkh@suse.de, David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
Subject: Re: [bug] usb build failure, latest -git
Message-ID: <20071014040423.GA30766@elte.hu>
References: <20071014032948.GA25760@elte.hu> <20071014033549.GQ8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014033549.GQ8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ftp.linux.org.uk> wrote:

> On Sun, Oct 14, 2007 at 05:29:48AM +0200, Ingo Molnar wrote:
> > 
> > FYI, the attached config fails to build on most recent -git with:
> > 
> >  In file included from drivers/usb/host/ohci-hcd.c:1038:
> >  drivers/usb/host/ohci-ssb.c:120: error: 'ohci_bus_suspend' undeclared here (not in a function)
> >  drivers/usb/host/ohci-ssb.c:121: error: 'ohci_bus_resume' undeclared here (not in a function)
> >  make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> 
> Subject: [PATCH] ohci-ssb with !CONFIG_PM

thanks :-)

	Ingo
