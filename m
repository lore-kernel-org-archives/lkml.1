Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbXLNWPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbXLNWPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbXLNWOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:14:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091AbXLNWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:14:51 -0500
Message-ID: <4763001A.1070102@zytor.com>
Date: Fri, 14 Dec 2007 14:13:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz>
In-Reply-To: <20071214210652.GB28793@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2007-12-14 10:02:57, H. Peter Anvin wrote:
>> Ingo Molnar wrote:
>>> wow, cool fix! (I remember that there were other systems as well that are 
>>> affected by port 0x80 muckery - i thought we had removed port 0x80 
>>> accesses long ago.)
>>> how about the simpler fix below, as a first-level approach? We can then 
>>> remove the _p in/out sequences after this.
>> I believe this will suffer from the issue that was raised: this will use 
>> udelay() long before loop calibration (and no, we can't just "be 
>> conservative" since there is no "conservative" value we can use.)
> 
> ?? Just initialize bogomips to 6GHz equivalent... and we are fine
> until 6GHz cpus come out.

How long will that take to boot on a 386?

	-hpa
