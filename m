Return-Path: <linux-kernel-owner+w=401wt.eu-S934017AbXDBMkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017AbXDBMkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXDBMkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:40:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:14698 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017AbXDBMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WSQ2yQjqa65yipQMBLXZkwV8Y2ibF2Yqnit3G4DGbKjRVRNT8podwB9+kRxCbymXRGUXzY9jeQ8cCAzvhD4wdBn9dMBJ5iQQAVjq0OJ6scQn60uWGGHy7eeA0aWjbI/w0URffmvz9UwDCsCba6DzxAdfX12cVeEZ6t8RnxxEp0M=
Message-ID: <d120d5000704020540i281912e0t8f6fd70f7785c5b8@mail.gmail.com>
Date: Mon, 2 Apr 2007 08:40:47 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Cc: "Li Yu" <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, "Marcel Holtmann" <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704021126280.3808@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051532096508636@gmail.com>
	 <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>
	 <4610609C.9030101@gmail.com> <200704020015.44167.dtor@insightbb.com>
	 <4610ABB1.3080606@gmail.com>
	 <Pine.LNX.4.64.0704021126280.3808@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/07, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 2 Apr 2007, Li Yu wrote:
>
> > Hi, I do not think that using blacklist in base driver for this purpose
> > is good idea. If so, we need modify source when each new HID device
> > driver come, that's so ugly.
>
> Hi Li,
>
> well, the drivers are exceptions from the generic handling, so creating an
> exceptional rule (entry in hid_blacklist) for them is not that bad. OK,
> it's not the nicest thing on earth probably, but serves the purpose in
> current vendors-trying-to-break-hardware-in-the-most-original-way world
> quite well.
>

Potentially we could even generate 2nd blacklist table automatically
by scanning MODULE_DEVICE_TABLEs for all drivers in HID directory and
merge it with the table we currently maintain in hid-input.c

> This is going to cause some headache to out-of-tree drivers. Oh well, do
> we care that much?

They still can be made to work using bind/unbind via sysfs, but at
this moment there are 0 drivers for HID bus and hopefully people will
be submittin them for inclusion.

-- 
Dmitry
