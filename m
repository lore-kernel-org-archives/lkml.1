Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYGDOLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYGDOLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYGDOK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:10:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46704 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYGDOKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:10:55 -0400
Message-ID: <486E2F68.2000707@garzik.org>
Date: Fri, 04 Jul 2008 10:10:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Takashi Iwai <tiwai@suse.de>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>	 <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <486CC440.9030909@garzik.org>	 <Pine.LNX.4.64.0807031353030.11033@blonde.site>	 <s5hmykxc3ja.wl%tiwai@suse.de>	 <1215177471.10393.753.camel@pmac.infradead.org>	 <s5hej69lqzk.wl%tiwai@suse.de>  <486E28BB.1030205@garzik.org> <1215179126.10393.771.camel@pmac.infradead.org>
In-Reply-To: <1215179126.10393.771.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Fri, 2008-07-04 at 09:42 -0400, Jeff Garzik wrote:
>> mkinitrd and similar scripts must be updated, so that drivers that 
>> worked prior to dwmw2's changes will continue to work after dwmw2's
>> changes.
> 
>> If you fail to update some script somewhere, then the driver will be 
>> copied into the initramfs, but not the firmware, with obvious results.
> 
> No, mkinitrd works fine, because a whole boatload of drivers _already_
> require it to work that way and have done for a long time.
> 
> Either you are severely mistaken, or you are being deliberately
> misleading.

It is a fact that mkinitrd, today, is unaware of your new system of 
obtaining firmware from the kernel source[or build] tree.

Certainly it is aware of the need to copy firmware in general, but that 
doesn't change the fact that the tg3 firmware will not make it into 
initramfs, without additional steps taken.

So, no, it doesn't "work fine" -- the firmware doesn't make it into the 
initramfs.

	Jeff


