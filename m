Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436Ab0ASU2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0ASU2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931Ab0ASU2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:28:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1280 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0ASU2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:28:19 -0500
Subject: Re: [PATCH] watchdogs: constify struct watchdog_info
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100119085613.GA3804@infomag.iguana.be>
References: <1263865537.18117.23.camel@Joe-Laptop.home>
	 <20100119085613.GA3804@infomag.iguana.be>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 12:28:17 -0800
Message-ID: <1263932897.18117.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 09:56 +0100, Wim Van Sebroeck wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/watchdog/acquirewdt.c     |    2 +-
> ...
> >  drivers/watchdog/wm8350_wdt.c     |    2 +-
> >  51 files changed, 52 insertions(+), 52 deletions(-)
> 
> NAK (Although the patch itself is good).

No worries.

> I created another patch that does this and moves the struct
> out of the ioctl call as part of the generic watchdog conversion.

Great.

I did send you awhile ago a patch series
to convert to pr_fmt() and pr_<level>.

http://lkml.org/lkml/2009/7/21/5

Do you still eventually want those?

cheers, Joe

