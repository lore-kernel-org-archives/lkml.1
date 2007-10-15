Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbXJOM74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbXJOM74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbXJOM7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:59:48 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55796
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759403AbXJOM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:59:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] usb build failure, latest -git
Date: Mon, 15 Oct 2007 14:58:54 +0200
User-Agent: KMail/1.9.6
Cc: Al Viro <viro@ftp.linux.org.uk>, gregkh@suse.de,
       David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
References: <20071014032948.GA25760@elte.hu> <20071014033549.GQ8181@ftp.linux.org.uk> <20071015105344.GA17028@elte.hu>
In-Reply-To: <20071015105344.GA17028@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151458.54817.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 12:53:44 Ingo Molnar wrote:
> 
> * Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > On Sun, Oct 14, 2007 at 05:29:48AM +0200, Ingo Molnar wrote:
> > > 
> > > FYI, the attached config fails to build on most recent -git with:
> > > 
> > >  In file included from drivers/usb/host/ohci-hcd.c:1038:
> > >  drivers/usb/host/ohci-ssb.c:120: error: 'ohci_bus_suspend' undeclared here (not in a function)
> > >  drivers/usb/host/ohci-ssb.c:121: error: 'ohci_bus_resume' undeclared here (not in a function)
> > >  make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> > 
> > Subject: [PATCH] ohci-ssb with !CONFIG_PM
> 
> there's a new build failure with latest -git:
> 
>  drivers/built-in.o: In function `ssb_ohci_probe':
>  ohci-hcd.c:(.text+0xbff39): undefined reference to `ssb_device_enable'
>  ohci-hcd.c:(.text+0xbff6f): undefined reference to `ssb_admatch_base'
>  ohci-hcd.c:(.text+0xbff8b): undefined reference to `ssb_admatch_size'
>  ohci-hcd.c:(.text+0xbffe5): undefined reference to `ssb_device_disable'
>  [...]
> 
> config attached.
> 
> 	Ingo
> 

I'm not sure why this happens. SSB is Y and ohci-hcd is also Y.
So why doesn't it find the syms?

-- 
Greetings Michael.
