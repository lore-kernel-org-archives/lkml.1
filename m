Return-Path: <linux-kernel-owner+w=401wt.eu-S1763117AbZFNThK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763117AbZFNThK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZFNTg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:36:59 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36806 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZFNTg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:36:58 -0400
X-Auth-Info: mRJotCbVN4U1Z1+NncCwT2CT4x9P614Dio47vhEc128=
Message-ID: <4A355155.4020500@grandegger.com>
Date: Sun, 14 Jun 2009 21:36:53 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Wolfram Sang <w.sang@pengutronix.de>, devicetree-discuss@ozlabs.org,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de>	<1244765062-14144-3-git-send-email-w.sang@pengutronix.de>	<20090614122136.GD3639@local>	<20090614171406.GA1010@pengutronix.de>	<20090614183357.GE3639@local>	<20090614190533.GA7387@pengutronix.de> <20090614192359.GG3639@local>
In-Reply-To: <20090614192359.GG3639@local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> On Sun, Jun 14, 2009 at 09:05:33PM +0200, Wolfram Sang wrote:
>>> Anyway, 0 is a valid IRQ number, so it cannot be used as "no irq".
>> May I point you to this thread?
>>
>> http://lkml.org/lkml/2005/11/21/221
> 
> Linus is just plain wrong in this 4 year old mail.

See also this related thread.

http://groups.google.com/group/rtc-linux/browse_thread/thread/9816648d5a8a1c9e/9968968188b5ab5a?lnk=gst&q=rx8025#9968968188b5ab5a

> 
>> (The issue comes up once in a while as some archs still use NO_IRQ, some with
>> 0 some with -1)
>>
>>>> 	if (uioinfo->irq == NO_IRQ)
>>>> 		uioinfo->irq = UIO_IRQ_NONE;
>>> Sorry for my ignorance, but what is NO_IRQ? If I do

It's 0 on PowerPC but ARM seems still to use -1.

http://lxr.linux.no/linux+v2.6.30/arch/powerpc/include/asm/irq.h#L29

For x86 it's not defined at all. But as this code is for the PowerPC,
where using NO_IRQ seems still to be OK.

Wolfgang.
