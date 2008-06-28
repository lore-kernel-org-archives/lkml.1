Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYF1N7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYF1N7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYF1N7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:59:16 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40384 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753293AbYF1N7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:59:15 -0400
Date: Sat, 28 Jun 2008 15:59:13 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628155913.2bba34a9@mjolnir.drzeus.cx>
In-Reply-To: <20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153403.0870e96c@mjolnir.drzeus.cx>
	<20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 15:47:00 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > 
> > Can't we use debugfs' own bookkeeping to keep track of them? Saves us a
> > lot of noise in these structures.
> 
> You mean d_subdirs in struct dentry? I guess we could do that...though
> I was sort of trying not to dig too deply into VFS internals...
> 

I'm a complete noob when it comes to debugfs. There isn't some
recursive delete function that can be used on the "ios" node?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
