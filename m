Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYH0X1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYH0X1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYH0X1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:27:04 -0400
Received: from gw.goop.org ([64.81.55.164]:32777 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbYH0X1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:27:03 -0400
Message-ID: <48B5E2C4.7060803@goop.org>
Date: Wed, 27 Aug 2008 16:27:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: /proc/acpi/ibm/wan stopped appearing
References: <48B5D11E.5090209@goop.org> <20080827231223.GB18081@khazad-dum.debian.net>
In-Reply-To: <20080827231223.GB18081@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 2. The proper way to control ANY radio's rfkill functions is through the
> rfkill sysfs interface.  That includes thinkpad-acpi's  bluetooth and WWAN.
>   

Do you know what UI-level programs make use of these interfaces now?

> IOW, we may have a regression here.  Please compile thinkpad-acpi with debug
> mode enabled, load it with the "debug=0xffff" and "experimental=1"
> parameters (as far as I remember, WWAN requires "experimental=1" to work,
> without that it will NOT load, and you will NOT get /proc/acpi/ibm/wan or
> anything else WWAN related from thinkpad-acpi), and send me the resulting
> log output from thinkpad-acpi.

Actually, that may be it.  I think I used to load it as a module, and
modprobe.conf set experimental=1, but I don't have an equivalent on the
kernel command line.

I think I'll submit a patch to remove the need for experimental; it's
been working fine for me for 3 years now.

    J
