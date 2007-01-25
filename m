Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbXAYV3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbXAYV3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXAYV3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:29:22 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:35903 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030581AbXAYV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:29:21 -0500
Message-ID: <45B9212E.2070100@profihost.com>
Date: Thu, 25 Jan 2007 22:29:18 +0100
From: Stefan Priebe - FH <studium@profihost.com>
User-Agent: Mozilla Thunderbird 1.0.7 (Windows/20050923)
X-Accept-Language: de-DE, de, en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel@vger.kernel.org, edmudama@gmail.com
Subject: Re: XFS or Kernel Problem / Bug
References: <20060801141545.B2326184@wobbly.melbourne.sgi.com> <44CED76B.20507@profihost.com> <20060801142755.C2326184@wobbly.melbourne.sgi.com> <44CED8F4.9080208@profihost.com> <20060801143212.D2326184@wobbly.melbourne.sgi.com> <44CEDA1D.5060607@profihost.com> <20060801143803.E2326184@wobbly.melbourne.sgi.com> <44CF36FB.6070606@profihost.com> <20060802090915.C2344877@wobbly.melbourne.sgi.com> <44D07AB7.3020409@profihost.com> <20060802201805.A2360409@wobbly.melbourne.sgi.com> <45B35CD7.4080801@profihost.com> <45B666BE.8000802@redhat.com> <45B70D69.20500@profihost.com> <45B773C1.7090805@redhat.com> <45B77547.4060302@profihost.com> <45B77780.5000504@redhat.com> <45B77C84.6070508@profihost.com> <45B78E9F.4000404@redhat.com> <45B7948B.70104@profihost.com> <45B79DCF.4040904@redhat.com> <45B7B334.2050904@profihost.com> <45B91894.3040604@redhat.com>
In-Reply-To: <45B91894.3040604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 84.133.245.39
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

OK - i rechecked everything. We've 22 Servers with the DFI PM-12 
Mainboard with VIA Chipset.

But only the 5 oldest of them (before 2004 / 01 / 20) (we've buyed all 
in a range of 10 month) have this problem.

So i think it is a mixture of software and hardware problem. Perhaps DFI 
changed something on the mainboard (e.g. new revision) or there was a 
new BIOS Version on it.

But there must also changed something in the kernel.

 > OK, can you post configs for one that works and one that doesn't?
You mean Kernel .configs?

 > And which C compiler(s) do you use? The same for all, I hope...
On all 32bit Machines:

gcc -v
Reading specs from /usr/lib/gcc-lib/i486-linux/3.3.5/specs
Configured with: ../src/configure -v 
--enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr 
--mandir=/usr/share/man --infodir=/usr/share/info 
--with-gxx-include-dir=/usr/include/c++/3.3 --enable-shared 
--enable-__cxa_atexit --with-system-zlib --enable-nls 
--without-included-gettext --enable-clocale=gnu --enable-debug 
--enable-java-gc=boehm --enable-java-awt=xlib --enable-objc-gc i486-linux
Thread model: posix
gcc version 3.3.5 (Debian 1:3.3.5-13)

Stefan


Chuck Ebbert schrieb:
> Stefan Priebe - FH wrote:
> 
>>>What is different about these servers?
>>
>>All 300 machines are mostly different. We have Dual Opteron, single P4
>>with HT, single P4 without HT, Dual Xeon, Athlon 64 X2, and many
>>more... different mainboards etc.
>>
>>The only thing i found out is, that all these servers (where the
>>problem exist) are using a DFI PM-12 Mainboard with a VIA Chipset.
> 
> Any others with VIA chipsets?
> 
>>>Are you building different kernels for them, or is it just different
>>>drivers loaded?
>>
>>No every machine builds it's own kernel.
>>
> 
> OK, can you post configs for one that works and one that doesn't?
> 
> And which C compiler(s) do you use? The same for all, I hope...
> 

