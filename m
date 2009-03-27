Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbZC0Umn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbZC0Umn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZC0Umd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:42:33 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:5461 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbZC0Umc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WsmeZRLfgBCZTTXUtO0hflOVJd97mn/uawWivnt446dva8ocTVhXKEUaOiY7GGbNiC
         7B6BIL+FjY8TlP/jYVhaTw6CwUmtCo3/ZDHR9Nu6Ew2HxJsx3PkBYEgXUe7suUXLUoMk
         sjdeWL3/Mv7qhQr1kLr08+gvzcQ64O25HiaOU=
Message-ID: <49CD399C.2000203@vflare.org>
Date: Sat, 28 Mar 2009 02:09:56 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] compressed in-memory swapping take3
References: <49C92E14.5060802@vflare.org> <200903262103.47919.edt@aei.ca>
In-Reply-To: <200903262103.47919.edt@aei.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Tomlinson wrote:
> On Tuesday 24 March 2009 15:01:40 Nitin Gupta wrote:
>> Hi,
>>
>> Project home: http://code.google.com/p/compcache/
> 
> I applied this to 2.6.29 and its not working correctly
> 
> I end up with lots of:
> 
> [69054.063788] Write-error on swap-device (254:0:13912)
> [69054.063820] Write-error on swap-device (254:0:13920)
> [69054.063853] Write-error on swap-device (254:0:13928)
> [69054.063888] Write-error on swap-device (254:0:13936)
> [69054.063904] Write-error on swap-device (254:0:13944)
> 
> type messages and trying to cat /proc/ramzswap causes an opps
> 
> [85235.133090] divide error: 0000 [#1] PREEMPT SMP
> [85235.133510] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/enable
> [85235.133510] CPU 0

Fixed. I will send out 'take4' with this fix and more cleanups.

Thanks a lot for reporting this issue.

- Nitin
