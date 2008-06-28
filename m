Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYF1OHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYF1OHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYF1OHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:07:45 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49825 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYF1OHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:07:44 -0400
Date: Sat, 28 Jun 2008 16:07:52 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628160752.0fe19753@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628155913.2bba34a9@mjolnir.drzeus.cx>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153403.0870e96c@mjolnir.drzeus.cx>
	<20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com>
	<20080628155913.2bba34a9@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 14:07:40.0287 (UTC) FILETIME=[537FE8F0:01C8D928]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Sat, 28 Jun 2008 15:47:00 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > 
> > > Can't we use debugfs' own bookkeeping to keep track of them? Saves us a
> > > lot of noise in these structures.
> > 
> > You mean d_subdirs in struct dentry? I guess we could do that...though
> > I was sort of trying not to dig too deply into VFS internals...
> > 
> 
> I'm a complete noob when it comes to debugfs. There isn't some
> recursive delete function that can be used on the "ios" node?

I don't think so, but I think it would be very useful. I sometimes
forget to remove an entry so that I have to reboot in order to get my
driver's debugfs interface going again..

Greg, do you have any suggestions?

Haavard
