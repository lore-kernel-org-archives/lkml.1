Return-Path: <linux-kernel-owner+w=401wt.eu-S966214AbXDDA5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966214AbXDDA5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966215AbXDDA5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:57:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:2059 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966214AbXDDA47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m9IVfuzNsmxC1mYA6iLQBIbaCDofFJocdET3Jado+bnCXtb8ttwBVxB3je6NbPumXbp0vVovhnshqzDs+VSM8EhhEEKNFfxlVJn7Q2nqGb1bUKcBqdzFcqCyjJXZl2kS8JJRTazL2T2UkOWHrqyJKPnuP6vpk3Y8wDN7CCcYpZI=
Message-ID: <4612F78E.5080303@gmail.com>
Date: Wed, 04 Apr 2007 08:55:42 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>  <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>  <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>  <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>  <1175516515.5815.347.camel@violet>  <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz> <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com> <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Current implementation (as you can see it in -mm or in my hid.git tree) is 
> creating hidraw interface for just every HID device/interface. But this 
> will get changed before merge.
>
> Passing just everything to hidraw is not a good option, as this could lead 
> to confusion and duplicating of input events (i.e. in-kernel hid driver 
> processes the report and generates input_event(), and also userland driver 
> obtains data from hidraw and generates input event through uinput ... not 
> good).
>
>   
After hearing your words, I change my implementation use hidraw as an
event filter, IOW, the HID core will handle these events which hidraw
can or need not handle. The modification is easy.

> BTW as soon as you have some presentable code, could you please send it so 
> that we could see what aproach you have taken? Debating over code is 
> usualy more efficient than just ranting random ideas :)
>
> Thanks,
>
>   

Of course, It's no problem. but it must be tomorrow, two reasons:

1. The development PC is at my home, I am not SOHO.
2. After change from "flip-flopping", the patch need some cleaning.

Good luck.

- Li Yu

