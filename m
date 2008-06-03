Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYFCCUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYFCCUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYFCCUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:20:17 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:3466 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbYFCCUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:20:15 -0400
X-IronPort-AV: E=Sophos;i="4.27,581,1204520400"; 
   d="scan'208";a="69427617"
Subject: Re: Blackfin Serial Driver: Enable IR function when user
	application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line
	discipline N_IRDA
From: gyang <graf.yang@analog.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080504165625.083d3d22@core>
References: <200804241929.m3OJToSE021045@hera.kernel.org>
	 <20080424215004.34517136@the-village.bc.nu>
	 <0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com>
	 <20080425105545.77b8c5e8@core>
	 <386072610805040827w7a606ee2ld24e6752a6c745c7@mail.gmail.com>
	 <20080504165625.083d3d22@core>
Content-Type: text/plain; charset=gbk
Date: Tue, 03 Jun 2008 10:18:46 +0800
Message-Id: <1212459526.6187.8.camel@dyang>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 03 Jun 2008 02:20:10.0515 (UTC) FILETIME=[5922FE30:01C8C520]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan,

Have the set_ldisc operator been put into main tree?

As current development cycle will end in few weeks, while rc4 kernel
still can't be compiled successfully because of this issue.

BRs,
Graf


在 2008-05-04日的 16:56 +0100，Alan Cox写道：
> > Oh, I got the compile failure now:
> > --
> >   CC      drivers/serial/bfin_5xx.o
> > drivers/serial/bfin_5xx.c: In function 'bfin_serial_init':
> > drivers/serial/bfin_5xx.c:1281: error: 'struct tty_driver' has no
> > member named 'set_ldisc'
> > make[2]: *** [drivers/serial/bfin_5xx.o] Error 1
> > make[1]: *** [drivers/serial] Error 2
> > make: *** [drivers] Error 2
> > --
> > 
> > Obviously, it is no way to change code like this for passing compiling:
> 
> I've added the uart set_ldisc operator to my tree. I thought Andrew had
> it as well, but if not I'll push it again Tuesday (Monday is a holiday
> here)
> 
> Alan
> --
> 	"Alan, I'm getting a bit worried about you."
> 				-- Linus Torvalds
