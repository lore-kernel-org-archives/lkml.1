Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbZLaIWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbZLaIWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 03:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZLaIWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 03:22:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63676 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZLaIV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 03:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kf8U3uGjAs0oPnNYOTP85QSWJOCjGI0LtScqhDKDUpVyZ0vJyDCJo+q/pcSnAAL65n
         6cmjPekhGwYjIBNghYCCWTEaEpCdogT/mlGw4qvVmoELnpMc785Tm0VrJVq9pr8UduTe
         8AKcy7rimr7Q23c9z2O8KmteZ/i4RWA7OFq5k=
Message-ID: <4B3C5F22.1080108@panasas.com>
Date: Thu, 31 Dec 2009 10:21:54 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl> <4B3C1137.8060308@tmr.com>
In-Reply-To: <4B3C1137.8060308@tmr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2009 04:49 AM, Bill Davidsen wrote:
> Yuhong Bao wrote:
>> Given that Linus was once talking about the performance penalties of PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of interest:
>> http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
>>
> I find these tests mirror my own experience with PAE, the benefit of having the 
> nx hardware enabled justifies the few percent drop in performance I was able to 
> find.
> 
> I find the huge gain in web service hard to believe without a hint why a 64 bit 
> CPU would be 15x faster. The disk, memory, and network wouldn't be faster, and 
> the CPU intensive tests weren't significantly faster, so unless the systems were 
> tuned differently where's the gain? Same feeling about the TP test, an order of 
> magnitude faster on a test running the same application on the same hardware is 
> hard to buy without an explanation.
> 

Why? simple, Memory. This system must have lots of memory (see the HIGHMEM64G) so
lots of IO must be bouncing on a 32bit system, where in 64bit it is copy-less.

Just my guess, but I'm not surprised.

> The only obvious source I can think of is running the test load at 100Mbit on
> one test and Gbit on another, because I saw an early network driver do just that
> in negotiations with a switch.
> 

Boaz
