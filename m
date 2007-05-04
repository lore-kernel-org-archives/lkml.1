Return-Path: <linux-kernel-owner+w=401wt.eu-S1030950AbXEDQEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030950AbXEDQEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbXEDQEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:04:15 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:59125 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbXEDQEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VDqDQJeL4MAuZXhGZBVAv/jF+MFLqe6EzfWPNmWlETbOsyYeW5X9RoXoJ9XS7qY2YdmQ23ogeiyG9TusmqxV49GzFcAz1XWWF4BYdSjypSGpAin9r3GToRKAkC48Flon9RKm6Ar4zrIqE8HWyfpBCq/S5Ri7AoTh6+xviLzX2+A=
Message-ID: <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
Date: Fri, 4 May 2007 18:04:08 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178290160.3913.2.camel@amdx2.microgate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <200705041049.20989.oliver@neukum.org>
	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com>
	 <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
	 <463B46F4.6090906@microgate.com> <463B4988.9090005@microgate.com>
	 <1178290160.3913.2.camel@amdx2.microgate.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> Here is a patch against 2.6.21 which flushes the tty flip buffer
> on ioctl(TCFLSH) for input.
>
> --- a/drivers/char/tty_io.c     2007-04-25 22:08:32.000000000 -0500
> +++ b/drivers/char/tty_io.c     2007-05-04 09:30:01.000000000 -0500
<snip>

Thanks! I've applied the patch and I'm building the kernel. I'll
report the result.


Regards,

  ~ Antonio
