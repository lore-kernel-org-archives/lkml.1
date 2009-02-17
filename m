Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZBQUBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZBQUBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZBQUBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:01:30 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45879 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZBQUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:01:28 -0500
Date: Tue, 17 Feb 2009 21:01:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       WimVanSebroeck@rhlx01.hs-esslingen.de
Subject: Re: [BUG] 2.6.29-rc2-git1 to -rc5: libata lockup on boot, LED
	solid, 100% CPU
Message-ID: <20090217200127.GA30981@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<wim@iguana.be>
Bcc: 
Subject: Re: [BUG] 2.6.29-rc2-git1 to -rc5: libata lockup on boot, LED
	solid, 100% CPU
Reply-To: 
In-Reply-To: <18841.54304.460011.351580@harpo.it.uu.se>
X-Priority: none

[CC'd Sergei and Wim; thanks a lot for your work!]

Hi,

On Mon, Feb 16, 2009 at 10:01:20PM +0100, Mikael Pettersson wrote:
> Andreas Mohr writes:
>  > Should I test 2.6.28.5? Every build will take two hours though...
>  > Not ATA-SFF 32bit bug problem, right? (already committed?)
>  > http://marc.info/?l=linux-kernel&m=123254501314058&w=2
> 
> To me it looks like the 32-bit PIO bug. The patch you cited above was
> just the first to identify the issue. This is still unfixed in 29-rc5.
> Please test Sergei's latest proposed patch posted yesterday to linux-ide.

Bingo. That patch ( http://marc.info/?l=linux-ide&m=123482861218381&w=2 )
made -rc5 boot for me. Well, after additionally disabling iTCO_wdt.ko,
that is... (on my Dell Inspiron 8000 i810)

And HDD did seem to be a wee bit more reponsive, too, but that could be
mere illusion...

Thanks,

Andreas Mohr
