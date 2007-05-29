Return-Path: <linux-kernel-owner+w=401wt.eu-S1751888AbXE2WUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbXE2WUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXE2WT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:19:59 -0400
Received: from tim.rpsys.net ([194.106.48.114]:41177 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbXE2WT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:19:59 -0400
Subject: Re: [PATCH] Samsung LTV350QV LCD driver
From: Richard Purdie <rpurdie@rpsys.net>
To: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200705291438.11581.david-b@pacbell.net>
References: <11804683571524-git-send-email-hskinnemoen@atmel.com>
	 <1180472477.5822.87.camel@localhost.localdomain>
	 <200705291438.11581.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 29 May 2007 23:19:43 +0100
Message-Id: <1180477183.5822.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 14:38 -0700, David Brownell wrote:
> On Tuesday 29 May 2007, Richard Purdie wrote:
> > The LCD class device bits look fine to me. The only change I'd request
> > is not to change the order of things in drivers/video/backlight/Kconfig.
> > If you do want to reword one of those entries (which is what I think you
> > wanted to do), send it as a separate patch please.
> 
> One significant issue was screwed up sequencing causing
> tools like 'xconfig' to display things wrong.  Appended
> is a patch fixing just that goof.

Put it like that, applied, thanks. :)

(http://git.o-hand.com/?p=linux-rpurdie-backlight;a=shortlog;h=for-mm)

> > David, any objections to the SPI bits?
> 
> They seemed fine to me, other than the write_reg() macro
> having an embedded 'goto' ... explicitly against the
> Documentation/CodingStyle guidelines.  ("Chapter 12",
> point 1 = "macros that affect code flow".)

Yes, even if it will make the code more ugly in a way, I think it needs
to be changed...

> I like seeing more of the SPI drivers go upstream.  ;)

;)

Cheers,

Richard

