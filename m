Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0BNUwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:52:34 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:57591 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab0BNUwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:52:32 -0500
Date: Sun, 14 Feb 2010 21:52:42 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
       nikola.ciprich@linuxbox.cz
Subject: Re: reading /proc/ioports causes OOPS
Message-ID: <20100214205242.GC4466@nik-comp.linuxbox.cz>
References: <20100214174513.GA4466@nik-comp.linuxbox.cz>
 <4B783CD2.1040209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B783CD2.1040209@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Milter-Copy-Status: O
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 3278247 records(14-02-2010)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My guess is that some module got unloaded and didn't unregister its
> ioport reservation, causing a segfault when the kernel tries to read
> the description string. Can you post the full dmesg output from
> bootup up to this point?
Hi, sure,
here it is: http://nelide.cz/downloads/dmesg.log
I see [last_unloaded]: freq_table there, loading the module back doesn't 
fix the problem. I could reboot the machine on wednesday, so I can try
reading /proc/ioports just after reboot to see if there is any change...
nik

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
