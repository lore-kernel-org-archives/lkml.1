Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXIWNVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXIWNVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 09:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXIWNVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 09:21:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48223 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbXIWNVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 09:21:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.6.23-rc7] main.c: undefined reference to `acpi_sleep_prepare'
Date: Sun, 23 Sep 2007 15:35:09 +0200
User-Agent: KMail/1.9.5
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200709230152.31120.elendil@planet.nl> <46F60AA2.1060500@gmail.com>
In-Reply-To: <46F60AA2.1060500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231535.09759.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 September 2007 08:41, Alexey Starikovskiy wrote:
> Frans Pop wrote:
> > I wanted to test 5a50fe709d527f31 and thus created a config with ACPI and 
> > CONFIG_HIBERNATION, but without CONFIG_SUSPEND, which resulted in (git 
> > checkout updated to 1f0cff6e4d579ab0):
> > 
> >   GEN     .version
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `acpi_power_off_prepare':
> > main.c:(.text+0x32282): undefined reference to `acpi_sleep_prepare'
> > drivers/built-in.o: In function `acpi_hibernation_prepare':
> > main.c:(.text+0x3228c): undefined reference to `acpi_sleep_prepare'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make[1]: Leaving directory `/home/fjp/projects/kernel/linux-2.6'
> > make: *** [debian/stamp-build-kernel] Error 2
> > 
> > 
> yep... acpi_sleep_prepare was put under CONFIG_SUSPEND spanning half of the file...
> this patch moves it out.

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
