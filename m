Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbXIRTVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbXIRTVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXIRTVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:21:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42486
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754203AbXIRTVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:21:33 -0400
Date: Tue, 18 Sep 2007 12:20:34 -0700 (PDT)
Message-Id: <20070918.122034.83625273.davem@davemloft.net>
To: hpa@zytor.com
Cc: mchan@broadcom.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F01BDE.6020902@zytor.com>
References: <1190141114.9540.216.camel@dell>
	<20070918.112337.74737433.davem@davemloft.net>
	<46F01BDE.6020902@zytor.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 18 Sep 2007 11:41:34 -0700

> David Miller wrote:
> > 
> > I don't like it because it means people have to setup full initrd's
> > in order to do network booting with such network cards.
> > 
> 
> klibc could help with that, if there is interest in exploring that
> avenue again.

I appreciate the effort you put into klibc and the offer to
make initrd's easier to build.

But the point is that the initrd shouldn't be necessary in the first
place.  There becomes zero point in building these drivers statically
into the kernel, which many of us do specifically to avoid module
loading, initrds, and all that fuss.  Because the driver is totally
crippled even though it's been fully built into the main kernel image.

I mean, it's so incredibly stupid and makes kernel development that
much more difficult.

Every new dependency, be it requiring initrd or something else,
is one more barrier added to kernel development.

I really pine for the days where everything was so simple, and initrd
and modules were the odd ball cases, most developers built everything
into their kernel image.
