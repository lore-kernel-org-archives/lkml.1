Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXLGR73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXLGR73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXLGR7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:59:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:44355 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXLGR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=veb3E7IYLvMr7HNKlpDTQDen75bXOWUmG9q+UD0yw3/V6HX22/RfId6k5DrK/8k3ZOaRj5KezR6BpkB8XvnrVrkYSOuJDi2VvRbO8FmI6Sv6PXTHbI6M0HdQj1FNrEfhqZW9R2chQPvRg0+DxAo+q01jPZe89UDLGiXLFA/NiQY=
Message-ID: <2c0942db0712070959v400901ax59f7b445ec701c27@mail.gmail.com>
Date: Fri, 7 Dec 2007 09:59:16 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: 2.6.24: false double-clicks from USB mouse
Cc: "Mark Lord" <lkml@rtr.ca>, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       rubini@vision.unipv.it, linux-input@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0712022300490.13260@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4752DB8C.50608@rtr.ca> <4752F6C7.4040904@rtr.ca>
	 <Pine.LNX.4.64.0712021918500.13260@jikos.suse.cz>
	 <4752FE11.2050200@rtr.ca> <4752FEFE.3000600@rtr.ca>
	 <Pine.LNX.4.64.0712022007360.13260@jikos.suse.cz>
	 <47530680.6020206@rtr.ca>
	 <Pine.LNX.4.64.0712022025250.13260@jikos.suse.cz>
	 <47530B32.7080502@rtr.ca>
	 <Pine.LNX.4.64.0712022300490.13260@jikos.suse.cz>
X-Google-Sender-Auth: cbce8fb5c53f4517
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 2, 2007 2:07 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> Thanks. To sum up this longish thread:
>
> - Mark seems to be able to reproduce the problem quite easily; I was not
>   successful reproducing this no matter how hard I tried, and I also
>   didn't receive any similar bugreports from anyone else
> - we are currently waiting for Mark to provide HID_DEBUG (and preferably
>   also usbmon) output from the situation where multiple clicks are
>   being generated incorrectly

Okay, I'm having a problem with 2.6.24-rc4 that I didn't with 2.6.23-rc6.

When the problem hits, my mouse (synaptics touchpad) is randomly
moving about and clicking things whenever I have my finger on the
trackpad. This behavior will persists for five to ten minutes (is
happening now), and seems to be triggered by load (watching online
videos in flash player, for example -- this matches Mark's experience
with a make -j4).

I *think* the touchpad is connected via ps2, which looks like it'd
clear usb of any blame. It's /dev/input/event6 at any rate.

This has been happening about once a day, and seems to start because
of high CPU usage. ONce the CPU is idle, it still happens though, so
I'm not sure why it clears up.

Any clues for where I should hunt from here?
