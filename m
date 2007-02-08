Return-Path: <linux-kernel-owner+w=401wt.eu-S1423251AbXBHT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423251AbXBHT2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423257AbXBHT2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:28:16 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:46811 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423251AbXBHT2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:28:15 -0500
Message-ID: <45CB79CF.9010702@gmail.com>
Date: Thu, 08 Feb 2007 20:28:15 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Reg Clemens <reg@dwf.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why can't I build a running Kernel?
References: <200702081817.l18IHlbE027996@deneb.dwf.com>
In-Reply-To: <200702081817.l18IHlbE027996@deneb.dwf.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reg Clemens napsal(a):
> Why can't I build a running Kernel?
> I have in the past, but since some time in the 2.6.19 series,
> I have got the following series of errors. 
> Same thing now with 2.6.20.
> 
> I build with:
> 
>     make xconfig
> 
> changing only the Processor type to Pentium4,
> then I
> 
>     make bzImage
>     make modules
>     make modules_install
>     make install
> 
> Fine everything builds, no errors.
> I then try booting, and I get 4 or 5 lines and then
> 
>     Unable to access resume device (/dev/sda5)
>     mount: could not find filesystem '/dev/root'
>     < 4 more lines with setuproot and switchroot >
>   
> and then
> 
>     Kernel panic - not syncing: Attempting to kill init!
> 
> Sigh.
> What has changed, what do I need to do to get this thing to boot?

Re-enable sata/scsi/usb/whatever is your root behind stuff back again? What does 
your .config look like?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
