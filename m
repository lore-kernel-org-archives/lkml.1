Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0BKVRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:17:01 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:16713 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab0BKVQ7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 11 Feb 2010 16:16:59 -0500
Date: Thu, 11 Feb 2010 15:56:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: viaum@sheridanc.on.ca
Subject: [viaum@sheridanc.on.ca: 2.6.33-rc7 (baremetal) fails to restart
	Intel i7 860 with P55 chipset.]
Message-ID: <20100211205640.GB7729@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B7473C2.00F5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anybody seen similar issues with their above mentioned motherboard?

The user has tried the 2.6.32.8 (no work), 2.6.33-rc7(no work), and
2.6.26-2(Debian - works).

I've asked him to pass in different reboot= arguments but no luck. Are
there any outstanding issues in regards to reboot that are known to the
community?

Thanks.

P.S.
Here is what the user said:
> > 2.6.32.8http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.8.tar.bz2
> > I will download the tarball and compile it ASAP.
> > 
> > **EDIT**
> > 
> > This kernel does the same hang. The good news is this might just be an issue with my hardware right? The bad news is I am not sure on what to try next. Has anyone got any suggestions?
> > 
> 
> Try the latest one. 2.6.33-rc<soimething> IT might have a fix for this.

OK. I will download that tarball and compile it ASAP.

http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.33-rc7.tar.bz2



**EDIT**



Same story as the last, reboot still hangs even with the newest kernel available.
Again the oddest thing is how the Debian 2.6.26-2-amd64 kernel reboots fine. Is
it possible that Linux does not yet support my style motherboard? Is it Debian
Lenny? Is there an issue with my /etc/inittab



# What to do when CTRL-ALT-DEL is pressed.

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now





If anyone else is running a similar hardware setup, what kernel are you using,
what kernel arguments do you pass at bootup, and does your Linux hang on
reboot?

