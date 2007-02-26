Return-Path: <linux-kernel-owner+w=401wt.eu-S1030354AbXBZR2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354AbXBZR2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030359AbXBZR2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:28:38 -0500
Received: from mail.setcomm.ru ([81.211.32.179]:52196 "EHLO mail.setcomm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030354AbXBZR2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:28:37 -0500
X-Greylist: delayed 1656 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 12:28:37 EST
Message-ID: <45E31248.7000301@kernelpanic.ru>
Date: Mon, 26 Feb 2007 20:00:56 +0300
From: "Boris B. Zhmurov" <bb@kernelpanic.ru>
Reply-To: bb@kernelpanic.ru
User-Agent: Thunderbird 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Pascal GREGIS <pgs@synerway.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: need some help on a backport of r8169
References: <20070226160824.GB14593@venus.synerway.com>
In-Reply-To: <20070226160824.GB14593@venus.synerway.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pascal GREGIS.

On 26.02.2007 19:08 you said the following:

> Hello everyone,
> 
> I am experiencing a big fight with a Realtek RTL8168 ethernet card
> that I need to use with a 2.6.11.11 kernel.
> 
> Here is my problem : the RTL8168 (which seems to be the PIC-express
> version of the RTL8169) isn't recognized by the 2.6.11.11 kernel. So
> I tried the r1000 driver supplied by Realtek, which recognizes my
> RTL8168 card but doesn't do what I want. In fact, it only supports
> ethtool for speed control and always uses autonegotiation to force a
> mode, which is also the behaviour of the r8169 driver but doesn't fit
> my needs because some of my company's clients use network switches
> that do not support autonegotiation.
> 
> I must precise that I previously succeeded to backport the support
> for mii-tool in the r8169 driver from the 2.6.20 kernel to the
> 2.6.11.11, which allows me to effectively force the speed without
> using autonegotiation. Ok, but that was for the RTL8169 card, already
> supported in the 2.6.11.11 kernel, now I need to support a RTL8168
> one.
> 
> So I tried a 2.6.20 kernel with this card and I saw that it was
> supported by the r8169 driver. So I decided to backport some of this
> driver to add the RTL8168 in it for the 2.6.11.11 kernel. I thought
> it was easy and just required to add some references (pci id ...) but
> sadly it isn't, and my patch results in a kernel panic when I turn
> the interface up.
> 
> Could anyone take a look at my patch and tell me what is missing, or
> what is wrong?


You, probably, should try to backport this patch:
http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.17-rc6/r8169/0005-r8169-sync-with-vendor-s-driver.txt

to your 2.6.11. Francois, please, correct me, if I'm wrong.



-- 
	boris
