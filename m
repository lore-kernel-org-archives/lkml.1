Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZHMWNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZHMWNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZHMWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:13:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:37712 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754426AbZHMWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:13:48 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18+kiIAq5s+DpXL1dhl9/Tk0vVHcTsm3ykSqFNRJD
	/zw6zRhUpgg9aU
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 28/74] thinkpad-acpi: fix incorrect use of TPACPI_BRGHT_MODE_ECNVRAM
Date: Fri, 14 Aug 2009 00:13:38 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-sidux-amd64; KDE/4.3.0; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       Len Brown <len.brown@intel.com>
References: <20090813194935.985368088@mini.kroah.org> <20090813195128.703325684@mini.kroah.org> <200908140006.45800.s.L-H@gmx.de>
In-Reply-To: <200908140006.45800.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908140013.48439.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 14 August 2009, Stefan Lippers-Hollmann wrote:
[...]
> > From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > 
> > commit 59fe4fe34d7afdf63208124f313be9056feaa2f4 upstream.
[...]
> > This fixes a regression in 2.6.30, bugzilla #13826
> 
> As already reported in [1] and confirmed by hmh in [2], this patch breaks 
> compiling thinkpad_acpi in 2.6.31-rc5.

ERR, 2.6.30.5-rc1 of course, it's fine in linux-2.6 HEAD/ 2.6.31-rc5[-git9]
as that contains the additionally required patches.

Sorry about the confusion.
	Stefan Lippers-Hollmann


[...]
>   CC [M]  drivers/platform/x86/hp-wmi.o
>   CC [M]  drivers/platform/x86/sony-laptop.o
>   CC [M]  drivers/platform/x86/thinkpad_acpi.o
> drivers/platform/x86/thinkpad_acpi.c:5769: error: array type has incomplete element type
> drivers/platform/x86/thinkpad_acpi.c:5771: error: implicit declaration of function 'TPACPI_Q_IBM'
> drivers/platform/x86/thinkpad_acpi.c: In function 'brightness_init':
> drivers/platform/x86/thinkpad_acpi.c:5799: error: implicit declaration of function 'tpacpi_check_quirks'
> drivers/platform/x86/thinkpad_acpi.c:5800: warning: type defaults to 'int' in declaration of 'type name'
> drivers/platform/x86/thinkpad_acpi.c:5800: warning: type defaults to 'int' in declaration of 'type name'
> drivers/platform/x86/thinkpad_acpi.c:5800: error: size of array 'type name' is negative
> make[6]: *** [drivers/platform/x86/thinkpad_acpi.o] Error 1
> make[5]: *** [drivers/platform/x86] Error 2
> make[4]: *** [drivers/platform] Error 2
> make[3]: *** [drivers] Error 2
> 
> Regards
> 	Stefan Lippers-Hollmann
> 
> [1]	From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
> 	Date: Fri, 7 Aug 2009 01:08:10 +0200
> 	Subject: Re: patch thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added to 2.6.30-stable tree
> 	Message-Id: <200908070108.15095.s.L-H@gmx.de>
> 	http://lkml.indiana.edu/hypermail/linux/kernel/0908.0/02520.html
> [2]	From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 	Date: Thu, 6 Aug 2009 20:31:11 -0300
> 	Subject: Re: patch thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added to 2.6.30-stable tree
> 	Message-ID: <20090806233111.GB14381@khazad-dum.debian.net>
> 	http://lkml.indiana.edu/hypermail/linux/kernel/0908.0/02526.html
> 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Reported-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[...]
