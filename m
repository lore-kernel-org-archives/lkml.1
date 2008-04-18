Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYDRAsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYDRAsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYDRAsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:48:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:39598 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbYDRAsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EbvahsQ/9WRbmEYPZczfSaAT5aV8BKDCI5cydDpKiY1PhFzio8dT9duEkJV0lRnXYnVEmJQZ0qvvs/4U94yiCLD2f9269an0H44DqD+28DZ0s0i4t0hCVga2Gb5EZ7bT/TA+gP2vAfwvF+is4HI6xIouR+1L9RhCLS3bcRF9Uic=
Message-ID: <3ae72650804171748y713c965bvbaf5de39e05ab555@mail.gmail.com>
Date: Fri, 18 Apr 2008 02:48:19 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <greg@kroah.com>
Subject: Re: 2.6.25-mm1: not looking good
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "James Morris" <jmorris@namei.org>,
       "Stephen Smalley" <sds@tycho.nsa.gov>
In-Reply-To: <20080417232441.GA19281@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	 <20080417232441.GA19281@kroah.com>
X-Google-Sender-Auth: 432d0f731f84edf9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 1:24 AM, Greg KH <greg@kroah.com> wrote:
>
> On Thu, Apr 17, 2008 at 04:03:31PM -0700, Andrew Morton wrote:
>  >
>  > I repulled all the trees an hour or two ago, installed everything on an
>  > 8-way x86_64 box and:

>  > usb/sysfs:
>  >
>  > ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 17 (level, low) -> IRQ 17
>  > uhci_hcd 0000:00:1d.0: UHCI Host Controller
>  > uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
>  > uhci_hcd 0000:00:1d.0: irq 17, io base 0x00002080
>  > usb usb1: configuration #1 chosen from 1 choice
>  > hub 1-0:1.0: USB hub found
>  > hub 1-0:1.0: 2 ports detected
>  > sysfs: duplicate filename '189:0' can not be created
>
>  Interesting, that's the new major:minor code.  I'll go poke at it...

Is this with the deprecated CONFIG_USB_DEVICE_CLASS=y? They have the
same dev_t as usb_device and would be a reason for the duplicates.

Thanks,
Kay
