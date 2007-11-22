Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXKWAnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXKWAnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbXKWAnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:43:05 -0500
Received: from mfbak.jpl.nasa.gov ([137.78.160.179]:56654 "EHLO
	mfbak.jpl.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXKWAnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:43:03 -0500
X-Greylist: delayed 2786 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2007 19:43:03 EST
Message-ID: <20071122155633.nzkk5gfz4go8ogc8@webmail.jpl.nasa.gov>
Date: Thu, 22 Nov 2007 15:56:33 -0800
From: niessner@jpl.nasa.gov
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
	<9a8748490711211816g5df5a81age77ad28c7382a11b@mail.gmail.com>
In-Reply-To: <9a8748490711211816g5df5a81age77ad28c7382a11b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
X-Source-IP: webmail1.jpl.nasa.gov [137.78.160.101]
X-Source-Sender: niessner@jpl.nasa.gov
X-AUTH: Authorized
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I do not think so. I have printk (KERN_NOTICE ...) scattered  
throughout to make sure the ioctl() is succeeding and to print out  
registers on the hardware. Those are showing up in /var/log/messages  
without a hitch. If there is a setting for printk in interrupts, then  
maybe because I would not know the macro to look for in the  
configuration.

Quoting Jesper Juhl <jesper.juhl@gmail.com>, on Wed 21 Nov 2007  
06:16:45 PM PST:

> On 22/11/2007, Al Niessner <Al.Niessner@jpl.nasa.gov> wrote:
>>
>> Quickly stated, I have a piece of hardware on the PCI bus that is
>> generating an interrupt (can watch it with a scope) but my handler is
>> not being called (no printk in /var/log/messages). So, where has the
>> interrupt gone?
>>
> Just to rule out the trivial causes. Could it be that you've simply
> not configured your system to log messages at the loglevel that your
> printk() is using?
>
> --
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
>


