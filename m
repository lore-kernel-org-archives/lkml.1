Return-Path: <linux-kernel-owner+w=401wt.eu-S1030646AbXAYWkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030646AbXAYWkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 17:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030647AbXAYWkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 17:40:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030646AbXAYWkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 17:40:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
Date: Thu, 25 Jan 2007 23:41:24 +0100
User-Agent: KMail/1.9.1
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <20070125113350.GA31068@elte.hu> <20070125180324.36E8B557CF8@chen.mtu.ru> <20070125212622.GB16722@waste.org>
In-Reply-To: <20070125212622.GB16722@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701252341.25514.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 25 January 2007 22:26, Matt Mackall wrote:
> On Thu, Jan 25, 2007 at 09:03:22PM +0300, Andrey Borzenkov wrote:
> > Ingo Molnar wrote:
> > > Make debugging such bugs easier by offering a resume mode that does not
> > > actually call into the BIOS to turn off the machine. This, in
> > > combination with earlyprintk=serial,ttyS0,115200,keep ,
> > > CONFIG_PM_DEBUG=y, CONFIG_DISABLE_CONSOLE_SUSPEND=y and
> > > /sys/power/filter enables me to have a fully functional serial console
> > > during the full suspend/resume cycle.
> > >
> > 
> > Will it work with netconsole too? COM port is often missing in notebooks
> > today.
> 
> Should, if you add your network device to the aforementioned filter.

Hm, what about the bus to which the device is connected?

Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
