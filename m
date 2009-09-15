Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZIOVmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZIOVmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbZIOVmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:42:05 -0400
Received: from dan.rpsys.net ([93.97.175.187]:50068 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbZIOVmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:42:04 -0400
Subject: Re: [RFC][PATCH] LED driver for Intel NAS SS4200 series
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1253047135.10449.11657.camel@nimitz>
References: <1253047135.10449.11657.camel@nimitz>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 22:38:24 +0100
Message-Id: <1253050704.30165.64.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 13:38 -0700, Dave Hansen wrote:
> This code is based on a driver that came in the "Open-source
> and GPL components" download here:
>     
> http://downloadcenter.intel.com/SearchResult.aspx?lang=eng&ProductFamily=Server+Products&ProductLine=Intel%C2%AE+Storage+Systems&ProductProduct=Intel%C2%AE+Entry+Storage+System+SS4200-E&OSVersion=OS+Independent
>     
> It was in a file called nasgpio.c inside of a second zip file
> called SS4200-E_Linux_SIO_Driver-v1.4.zip.
> 
> That code used an ioctl() call to operate the LEDs.  It also
> created a new top-level /proc file just to let userspace locate
> which dynamic major number had been allocated to the device.
> I decided that the interface probably wasn't mergeable in that
> form. :)
>     
> I ripped out all of the hardware monitor support from nasgpio.c
> as well as the smbus code that controls the LED brightness.  I
> then converted the code to use the existing LED interfaces
> rather than the ioctl().  I don't have any need for brightness
> control, and its code is *completely* separate from the on/off
> controls implemented here.  If anyone else wants it, I'd be
> happy to look into adding it, but I don't care enough for now.

At a quick review this looks good. One question: These LEDs appear to be
attached to generic GPIOs on a southbridge that is probably in other
devices? If so, how do we know they're connected to LEDs? Do we need to
add some further check of what kind of device we're running on?

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

