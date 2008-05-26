Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYEZLLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYEZLLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYEZLLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:11:25 -0400
Received: from server.drzeus.cx ([85.8.24.28]:48862 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753934AbYEZLLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:11:25 -0400
Date: Mon, 26 May 2008 13:10:26 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, hpa@zytor.com
Subject: Re: gcc "internal error" with 32-bit userspace, 64-bit kernel
Message-ID: <20080526131026.1f14bddd@mjolnir.drzeus.cx>
In-Reply-To: <alpine.LFD.1.10.0805261211040.3295@apollo.tec.linutronix.de>
References: <20080525112728.6341c113@mjolnir.drzeus.cx>
	<alpine.LFD.1.10.0805261211040.3295@apollo.tec.linutronix.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 12:12:25 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> 
> Just tried to reproduce that with git of today. Did not happen.
> 
> Which kernel version are you using ?
> 

Linux builder-f9.drzeus.cx 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

Package I'm building is this one:

http://apt.drzeus.cx/oee/5/SRPMS/courier-0.59.0-1.el5.src.rpm

which also needs:

http://apt.drzeus.cx/oee/5/SRPMS/courier-authlib-0.60.4-1.el5.src.rpm

http://apt.drzeus.cx/oee/5/i386/courier-authlib-0.60.4-1.el5.i386.rpm
http://apt.drzeus.cx/oee/5/i386/courier-authlib-devel-0.60.4-1.el5.i386.rpm

Being built using this command:

mock -r epel-5-i386 --rebuild courier-0.59.0-1.el5.src.rpm

Result in build.log:

ar cru .libs/librewrite.a  esmtp.o
ranlib .libs/librewrite.a
creating librewrite.la
(cd .libs && rm -f librewrite.la && ln -s ../librewrite.la librewrite.la)
gcc: Internal error: Killed (program cc1)
Please submit a full bug report.
See <URL:http://bugzilla.redhat.com/bugzilla> for instructions.
make[4]: *** [esmtpclient.o] Error 1
make[3]: *** [all] Error 2
make[2]: *** [all-recursive] Error 1
make[1]: 
*** [all] Error 2
make: 
*** [all-recursive] Error 1
error: 
Bad exit status from /var/tmp/rpm-tmp.81020 (%build)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
