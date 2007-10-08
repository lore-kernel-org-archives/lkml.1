Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbXJHDbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbXJHDbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 23:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbXJHDbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 23:31:32 -0400
Received: from 1wt.eu ([62.212.114.60]:2833 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbXJHDbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 23:31:31 -0400
Date: Mon, 8 Oct 2007 05:29:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Message-ID: <20071008032927.GB28755@1wt.eu>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <Pine.LNX.4.64.0710072123460.16301@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710072123460.16301@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 09:56:09PM +0200, Jan Engelhardt wrote:
> 
> On Oct 7 2007 21:13, Willy Tarreau wrote:
> >There are two distinct populations :
> >  - those [...]
> >    who would never have imagined that pressing Escape
> >    during the boot of windows 3.1/95 provided them with the full text
> >    messages.
> 
> This is news to me. DOS always showed messages, and under Win95,
> it was either F8 or removing logo.sys. I did troubleshoot it ;-)

You remember that you could start them both from DOS by typing "win" ?
If you hit ESC during the first seconds when the logo showed, you could
get back to text mode to see the messages.

> >  - those who are troubleshooting their system [...]
> >
> >I personally fit in the second category.
> >
> >I would say that while I'm not particularly fond of flashy colors
> >everywhere
> 
> I have to agree so really. Just because there's a color option for 
> everything does not mean one should use it.
> 
> In fact, I moved away[2] from the default Midnight Commander styling 
> because it's just - as Dave calls it - salad colors[1].

I found them "fun", it reminded me of the DOS-version of borland C, 15
years ago :-)

> Some is good, as long as it is not excessive. While I could imagine that 
> Knoppix will abuse the feature and use vt.printk_color=9,9,9,9,11,10,12, 
> this is not what serious people would do.

One solution against this and which may satisfy people who are against
this idea, would be to just manipulate the bold and reverse attributes
for errors. On VGA consoles, this would translate into printing in
white instead of grey, and it could also work on ANSI/vt100 terminals.

After all, if the initial intention was to report errors in a more
noticeable way, let's not let the user choose the colors and have
them defined the hard way. It will prevent the salad colors from
appearing.

Willy

