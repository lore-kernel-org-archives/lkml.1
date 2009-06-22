Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZFVRhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZFVRhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZFVRhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:37:43 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:36531 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZFVRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t3TmW9hfS/ZWEkgYyZ0nelTcOh8oS+WMjUJ2Chp3W3DxCpGCwabKIm1VC3SBytfmNF
         hPaXuVzaC8JjNBDOyM5wQVcDpdy8O1pIBVjH6XNNL4WZrPNcnyrD95Zfwwf/b4DmyBRk
         iamlnarMe57uVG5dtdCqWUqTnQbRq0/A6Kh1k=
MIME-Version: 1.0
In-Reply-To: <4A3FB7BE.9080203@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com>
	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
	 <4A3F55C7.4030909@linux.intel.com>
	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
	 <4A3F7A93.5080004@linux.intel.com>
	 <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>
	 <4A3F8BF7.6010406@linux.intel.com>
	 <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com>
	 <4A3FB7BE.9080203@linux.intel.com>
Date: Mon, 22 Jun 2009 19:37:43 +0200
Message-ID: <8db1092f0906221037m30c7966bx6870b4eeb9ee16ea@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Andi Kleen <ak@linux.intel.com>:

>
> Weird.
>
> And again can you double check it doesn't hang with check_interval = 0
> in this setup? (just to make sure)

To be clear: I do s2disk immediately after boot. System never hangs
after normal boot.

I do this test:

1. boot, don't change check_interval
2. suspend to disk
3. wait 10 minutes
4. resume
5. When finish resume uptime shows 12 minutes
6. hangs when uptime shows 15 minutes

Second test:
Another machine (laptop) has the same issue
1. boot, don't change check_interval
2. suspend to disk
3. don't wait
4. resume
5. hangs when uptime shows 5 minutes


I already do this test:
1. boot, check_interval=0
2. suspend to disk
3. wait 10 minutes
4. resume

I show result in next e-mail, please be patient.



-- 
Maciej Rutecki
http://www.maciek.unixy.pl
