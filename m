Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbXKAJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbXKAJ2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbXKAJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:28:42 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:10560 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbXKAJ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=Ea+uwIjOSWktKDYxP6GhZD0hQ/xkTth2xihw43sAGlEVFZjeckWpEpb1DTWwKT3Eyk9XTmTlCPtfb4MFYneD+IbYudQFd6F1xGEWkcwgU3PuARQrLK48GdT3YC8FyvMEBkqK00vPd8bjT/Eoyavus9Y/DhZLArhaQ3S1heVSCeQ=
Message-ID: <47299C43.1070703@qumranet.com>
Date: Thu, 01 Nov 2007 11:28:35 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Brown <dmlb2000@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>
In-Reply-To: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown wrote:
> Uhm, not sure who to send this too...
>
> I thought I'd try out the realtime patch set and it didn't work at all
> with kvm. The console didn't dump anything and the system completely
> locked up.
>
> Anyone have any suggestions as to how to get more output on this issue?
>
> It got to the point of bringing up the tap interface and attaching it
> to the bridge but that was about it for the console messages.
>
> Thanks,
> - David Brown
>
>   
I tried to recreate your problem using 2.6.23-1 and latest rt patch (rt5).
The problem is that the kernel is not stable at all, I can't even 
compile the code over vnc -
my connection is constantly lost. So it might not be kvm problem?
Can you try is with -no-kvm and see if it's working - then its just a 
regular userspace process.

Anyway if all other things are stable on your end, can you send us 
dmesg/strace outputs?
Also try without the good -no-kvm-irqchip.
Regards,
Dor.
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>
>   

