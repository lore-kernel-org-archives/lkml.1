Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZFHLA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZFHLA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZFHLAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:00:17 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:40363 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZFHLAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:00:16 -0400
Message-ID: <4A2CEF3F.1020900@msgid.tls.msk.ru>
Date: Mon, 08 Jun 2009 15:00:15 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: solved: Re: 2.6.30-rc8 does not boot
References: <4A2CE6AC.4030403@msgid.tls.msk.ru> <4A2CEC5B.3000001@msgid.tls.msk.ru>
In-Reply-To: <4A2CEC5B.3000001@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[2nd reply to my own email...]

Michael Tokarev wrote:
> Michael Tokarev wrote:
>> Hello.
>>
>> I just gave 2.6.30-rc a try, taken from Linus git, tag v2.6.29-rc8.
>> And this one does not want to boot on my test machine which is an
>> AMD X2-64 with AMD780G chipset.  Neither 64 nor 32bit kernel boots.
>> I even tried in kvm virtual machine, -- same effect.  It freezes right
>> after displaying "Verifying BIOS data successful" message -- nothing
>> more is on the screen.
>>
[]
> Loading kernel ....
> Loading initrd ....
> BIOS data check successful
> 
> PANIC: early exception 0e rip: 10:ffffffff802c9abd error 0 cr2 0

It turned out to be an issue with acpi-dsdt-initrd-v0.9c-2.6.29.patch
which I forgot to remove from my package when rebuilding the kernel.
Reverting that patch solved boot issues and the kernel is now working.

Please excuse me for the noise.

Thanks!

/mjt
