Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbZHNVfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbZHNVfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbZHNVfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:35:55 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33820 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755907AbZHNVfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:35:54 -0400
Message-ID: <4A85D89F.8080900@acm.org>
Date: Fri, 14 Aug 2009 15:35:27 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
References: <20090814170228.GM13320@pengutronix.de> <4A85AAC4.7050505@acm.org>	 <20090814185731.GN13320@pengutronix.de> <63386a3d0908141401t6050f39ey8d85213aeccf748a@mail.gmail.com>
In-Reply-To: <63386a3d0908141401t6050f39ey8d85213aeccf748a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090814/1Mc4Qy-0003jW-3W-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 2009/8/14 Robert Schwebel <r.schwebel@pengutronix.de>:
>> On Fri, Aug 14, 2009 at 12:19:48PM -0600, Zan Lynx wrote:
> 
>>>> That's factor 70 away from the 110 ms boot time Tim has talked about
>>>> some days ago (and he measured on an ARM cpu which had almost half
>>>> the speed of this one), and I'm wondering what we can do to improve
>>>> the boot time.
>>> 2.4s in uncompression? That seems like an obvious target for
>>> improvement.
>> Indeed, we'll check that.
> 
> We got rid of uncompression on a flash-based system vastly improving
> boot time. The reason is that compressed kernels are faster only when
> the throughput to the persistent storage is lower than the decompression
> throughput, and on typical embedded systems with DMA the throughput to
> memory outperforms the CPU-based decompression.

I thought of another thing to check related to slow decompression. If 
the kernel, bootloader or hardware is in charge of setting CPU power and 
speed scaling, then you should check that it boots with the CPU set at 
maximum speed instead of slowest.

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
