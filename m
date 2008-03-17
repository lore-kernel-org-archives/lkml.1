Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYCQB2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYCQB2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYCQB2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:28:15 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:35780 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751594AbYCQB2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:28:14 -0400
Message-ID: <47DDC92A.7000703@gawab.com>
Date: Sun, 16 Mar 2008 18:28:10 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bryce Harrington <bryce@canonical.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803141029.38124.jbarnes@virtuousgeek.org> <47DB46F1.80106@gawab.com> <200803151035.23808.jbarnes@virtuousgeek.org>
In-Reply-To: <200803151035.23808.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> No problem, building X still isn't quite as easy as it should be, but it's 
> only slightly more complicated than the typical './configure;make;make 
> install' due to the dependencies between packages.  You can check out the X 
> wiki (wiki.x.org), there are some hints on building things there.
>   

I'm just compiling the intel_reg_dumper right? I don't have to recompile 
all of X to use it?

Bryce Harrington wrote:
> The following command will pull in all the dependencies you need for
> building -intel:
>
>  sudo apt-get build-dep xserver-xorg-video-intel

Ok, got that. I tried to compile and I found out I also had to install 
libpciaccess-dev, that's probably because I'm using the git tree and not 
the one that Ubuntu 7.10 uses. But I still can't compile the 
intel_reg_dumper I get the following error:

intel-driver/src/reg_dumper$ make
gcc -DHAVE_CONFIG_H -I. -I../.. -Wall -Wpointer-arith 
-Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations 
-Wnested-externs -fno-strict-aliasing -I./.. -DREG_DUMPER -g -O2 -MT 
main.o -MD -MP -MF .deps/main.Tpo -c -o main.o main.c
main.c: In function ‘main’:
main.c:72: warning: implicit declaration of function ‘pci_device_map_range’
main.c:72: warning: nested extern declaration of ‘pci_device_map_range’
main.c:75: error: ‘PCI_DEV_MAP_FLAG_WRITABLE’ undeclared (first use in 
this function)
main.c:75: error: (Each undeclared identifier is reported only once
main.c:75: error: for each function it appears in.)
make: *** [main.o] Error 1

Justin
