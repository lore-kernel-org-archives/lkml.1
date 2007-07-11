Return-Path: <linux-kernel-owner+w=401wt.eu-S1764737AbXGKPc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764737AbXGKPc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbXGKPcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:32:21 -0400
Received: from herkules.vianova.fi ([194.100.28.129]:51432 "HELO
	mail.vianova.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753622AbXGKPcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:32:20 -0400
Date: Wed, 11 Jul 2007 18:32:15 +0300
From: Ville Herva <v@iki.fi>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 Oops attaching usb-storage device
Message-ID: <20070711153215.GU22103@vianova.fi>
Reply-To: v@iki.fi
References: <20070711125957.GT22103@vianova.fi> <6bffcb0e0707110717v2111b54do20e42e9add2b905b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707110717v2111b54do20e42e9add2b905b@mail.gmail.com>
X-Operating-System: Linux herkules.vianova.fi 2.4.32-rc1
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 04:17:14PM +0200, you [Michal Piotrowski] wrote:
> Hi,
> 
> On 11/07/07, Ville Herva <v@iki.fi> wrote:
> >[98790.366620] Modules linked in: ub nvidia(P) ppp_deflate zlib_deflate 
>
> "When you are using a binary driver, the kernel is "tainted", which
> means that the source of possible problems may be unrelated to the
> kernel code (see
> https://secure-support.novell.com/KanisaPlatform/Publishing/250/3582750_f.SAL_Public.html
> for more details). You can check whether or not the kernel was tainted
> when the problem occurred by looking at the corresponding error
> message. If can you see something similar to the following line:
> EIP:      0060:[<c046c7c3>]         Tainted: P      VLI
> (the word Tainted is crucial here), the kernel was tainted and most
> probably the kernel developers will not be able to help you. In that
> case you should try to reproduce the problem without the binary driver
> loaded. Moreover, if the problem does not occur without it, you should
> send a bug report to the creators of the binary driver and ask them to
> ???x it."

Thanks, I do know the kernel was tainted (Nvidia display driver). 

I didn't explicitly mention that in the report, since the kernel developers
see that from the oops message, and because I believe there is a fair change
that the hated nvidia module played no role in this case. Of course, there's
no way to be sure, as it is closed source.

I sent the oops message just in case the usb-storage / usb people can get an
idea from the stack trace what might have gone wrong. I believe it was worth
it even though nvidia module might in theory make the problem unsolvable. 

The problem is spurious (not reproducible). I attached and removed the Nokia
device quite some times today and yesterday without problems, and this only
happened once. 

As regards to nvidia being able to fix this problem, I sure you understand
that will not happen :) Even if it was the nvidia driver mucking arounf the
kernel address space, that would have to be very random and this oops
message couldn't help them.



-- v -- 

v@iki.fi

