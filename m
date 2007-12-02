Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbXLBWq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbXLBWq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXLBWqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:46:49 -0500
Received: from rtr.ca ([76.10.145.34]:1342 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbXLBWqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:46:48 -0500
Message-ID: <475335D6.8070902@rtr.ca>
Date: Sun, 02 Dec 2007 17:46:46 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.24:  false double-clicks from USB mouse
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca> <Pine.LNX.4.64.0712021903460.12208@twin.jikos.cz> <4752F6C7.4040904@rtr.ca> <Pine.LNX.4.64.0712021918500.13260@jikos.suse.cz> <4752FE11.2050200@rtr.ca> <4752FEFE.3000600@rtr.ca> <Pine.LNX.4.64.0712022007360.13260@jikos.suse.cz> <47530680.6020206@rtr.ca> <Pine.LNX.4.64.0712022025250.13260@jikos.suse.cz> <47530B32.7080502@rtr.ca> <Pine.LNX.4.64.0712022300490.13260@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0712022300490.13260@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> [ linux-usb-devel added to CC ]
> 
> On Sun, 2 Dec 2007, Mark Lord wrote:
> 
>> Okay.  I've got to leave the computer for a while now, so I'll post 
>> again whenever I have something new here.
> 
> Thanks. To sum up this longish thread:
> 
> - 2.6.24-rcX exposes the problem with sometimes multiple clicks being 
>   generated as a response for one click on USB mouse (evtest shows that 
>   really mutliple LeftBtn events arrive). 2.6.23 behaves correctly
> - reverting the state of drivers/hid to 2.6.23 state doesn't make the 
>   problem go away, so the problem is elsewhere (Input? USB?)
> - Mark seems to be able to reproduce the problem quite easily; I was not 
>   successful reproducing this no matter how hard I tried, and I also 
>   didn't receive any similar bugreports from anyone else
> - we are currently waiting for Mark to provide HID_DEBUG (and preferably
>   also usbmon) output from the situation where multiple clicks are 
>   being generated incorrectly
..

Well, I've rebuilt the kernel with HID_DEBUG, DEBUG_FS, and USBMON.
And I've written a nifty script to make usbmon tracing effortless for this.

And now I'm waiting.. things are currently behaving perfectly.
Go figure.  It did seem to arrive in bursts before.

So, don't beat yourselves over this one for now.
I'll track it down here and post again next time it starts happening.

Mmmm...

