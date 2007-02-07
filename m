Return-Path: <linux-kernel-owner+w=401wt.eu-S1161177AbXBGKoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161177AbXBGKoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161175AbXBGKoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:44:37 -0500
Received: from serv04.lahn.de ([213.239.197.57]:49334 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161177AbXBGKog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:44:36 -0500
Date: Wed, 7 Feb 2007 11:43:46 +0100
From: Michael Leun <ml@newton.leun.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, mitr@volny.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wistron button support for fujitsu-siemens Amilo D88x0
Message-ID: <20070207114346.73eecf40@xenia.leun.net>
In-Reply-To: <20070207095807.GA15088@srcf.ucam.org>
References: <20070205103521.0f20779d@xenia.leun.net>
	<20070205110529.0e4ae6c0@xenia.leun.net>
	<d120d5000702060837j7382d429ned3fb5a5e47ac76b@mail.gmail.com>
	<20070206194318.1d8e1fc0@xenia.leun.net>
	<20070206200748.GA24176@srcf.ucam.org>
	<20070207072347.7b30781d@xenia.leun.net>
	<20070207095807.GA15088@srcf.ucam.org>
Organization: Not Organized
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 09:58:07 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Feb 07, 2007 at 07:23:47AM +0100, Michael Leun wrote:
> > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > Hm. Is there really no PNP id that tends to be associated with
> > > this wistron hardware? Fujitsu (at least) seem to be quite good at
> > > exposing a lot of their magic hardware that way.
> > 
> > Sorry, I do not know and I do not know how to find out. If there is
> > any testing I should do on my machine I will happily do that, but
> > you would have to tell me what to do.
> 
> cat /sys/bus/pnp/devices/*/id should give a list of the available IDs.

ml@xenia:~> cat /sys/bus/pnp/devices/*/id
PNP0a03
PNP0200
PNP0b00
PNP0800
PNP0c02
PNP0c04
PNP0303
PNP0f13
PNP0700
PNP0400
PNP0501

OK, it does, but what to do with them?

Looking around there shows that some of them cover kbd, psaux,
parport, and serial.

ml@xenia:/sys/bus/pnp/devices> for i in *; do ls -l $i/; done
insgesamt 0
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:27 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:27 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:27 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:27 uevent
insgesamt 0
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
lrwxrwxrwx 1 root root    0  7. Feb 11:28 driver -> ../../../bus/pnp/drivers/system
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
lrwxrwxrwx 1 root root    0  7. Feb 11:28 driver -> ../../../bus/pnp/drivers/i8042 kbd
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
lrwxrwxrwx 1 root root    0  7. Feb 11:28 driver -> ../../../bus/pnp/drivers/i8042 aux
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
lrwxrwxrwx 1 root root    0  7. Feb 11:28 driver -> ../../../bus/pnp/drivers/parport_pc
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
--w------- 1 root root 4096  7. Feb 11:28 uevent
insgesamt 0
lrwxrwxrwx 1 root root    0  7. Feb 11:28 driver -> ../../../bus/pnp/drivers/serial
-r--r--r-- 1 root root 4096  7. Feb 11:27 id
-r--r--r-- 1 root root 4096  7. Feb 11:28 options
drwxr-xr-x 2 root root    0  7. Feb 11:28 power
-rw-r--r-- 1 root root 4096  7. Feb 11:28 resources
lrwxrwxrwx 1 root root    0  7. Feb 11:28 subsystem -> ../../../bus/pnp
drwxr-xr-x 3 root root    0  7. Feb 11:28 ttyS0
--w------- 1 root root 4096  7. Feb 11:28 uevent


-- 
MfG,

Michael Leun

