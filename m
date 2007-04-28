Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXD1Ffv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXD1Ffv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbXD1Ffv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:35:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:36495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbXD1Fft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:35:49 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Riccardo Ricci" <rricci@nuovanetmore.it>, linux-acpi@vger.kernel.org
Subject: Re: Problem 2.6.21
Date: Sat, 28 Apr 2007 01:34:08 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <40771.172.20.1.1.1177699187.squirrel@srv01.nuovanetmore.it>
In-Reply-To: <40771.172.20.1.1.1177699187.squirrel@srv01.nuovanetmore.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280134.08636.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 14:39, Riccardo Ricci wrote:
> 
> Hi to everyone,
> i've compiled kernel 2.6.21 on my debian PIII 650 / 256MB / Dell Latitude
> J650GT. With 2.6.20.8 all works very good, with 2.6.21 don't boot... While
> booting it stops after ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9
> 10 11 12 14 15).

Does 2.6.20.8 boot with acpi=off, does 2.6.21?

Any chance you can get the serial console log of the failure when booted with "debug"?
Also, the 2.6.20.8 dmesg is missing the beginning, try dmesg -s64000 --
though it will probably not be very interesting until 2.6.21 output is available to compare to it.

thanks,
-Len
