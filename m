Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbXKGQWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbXKGQWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXKGQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:21:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:34028 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXKGQV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:21:56 -0500
Date: Wed, 7 Nov 2007 08:21:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, mingo@elte.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc2 build fails: implicit declaration of function
 =?UTF-8?Q?=E2=80=98smp=5Fcall=5Ffunction=5Fmask'?=
Message-Id: <20071107082126.57a5d35c.randy.dunlap@oracle.com>
In-Reply-To: <20071107095555.GB26962@traven>
References: <alpine.LFD.0.999.0711061601180.15101@woody.linux-foundation.org>
	<20071107095555.GB26962@traven>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007 10:55:55 +0100 Matthias Kaehlcke wrote:

> v2.6.24-rc2 fails to build on my box with the following error:
> 
> CC [M]  drivers/kvm/kvm_main.o
> drivers/kvm/kvm_main.c: In function ‘kvm_flush_remote_tlbs’:
> drivers/kvm/kvm_main.c:220: error: implicit declaration of function
> ‘smp_call_function_mask’
> make[3]: *** [drivers/kvm/kvm_main.o] Error 1
> make[2]: *** [drivers/kvm] Error 2
> make[1]: *** [drivers] Error 2
> make[1]: Leaving directory `/data/kernel/linux-2.6.24-rc2'
> make: *** [debian/stamp-build-kernel] Error 2
> 
> the .config file is attached

Ingo has a patch that he was going to push for this.

---
~Randy
