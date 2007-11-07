Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXKGBul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXKGBul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXKGBuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:50:32 -0500
Received: from exchange.columbia.tresys.com ([216.250.243.126]:4657 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754121AbXKGBub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:50:31 -0500
Message-ID: <473119E6.7070904@manicmethod.com>
Date: Tue, 06 Nov 2007 20:50:30 -0500
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, paul.moore@hp.com
Subject: Re: [PATCH] NetLabel: Introduce a new kernel configuration API for
 NetLabel - For 2.6.24-rc-git11 - Smack Version 10
References: <472BF1D0.3070108@schaufler-ca.com> <47310FF3.3080003@manicmethod.com>
In-Reply-To: <47310FF3.3080003@manicmethod.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Nov 2007 01:50:30.0437 (UTC) FILETIME=[93CAE550:01C820E0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua Brindle wrote:
> Casey Schaufler wrote:
>> From: Paul Moore <paul.moore@hp.com>
>>
>> Add a new set of configuration functions to the NetLabel/LSM API so that
>> LSMs can perform their own configuration of the NetLabel subsystem 
>> without
>> relying on assistance from userspace.
>>   
> I'm still not receiving the actual patch email on lsm (perhaps its too 
> long and should be split up..) so I'll just respond on this email. 
> Using the v10 patches on your website I'm still seeing strange 
> behavior where echo foo > /proc/self/attr/current changes the label of 
> every process on the system to foo (verified with both ps -AZ and cat 
> /proc/1/attr/current).
>
Actually I'm getting more strange behavior:

On terminal 1 I do:
echo foo > /proc/self/attr/current
then ps -AZ shows foo for every process
touch somefile; attr -S -g SMACK64 somefile says foo

On terminal 2 I do:
ps -AZ and everything shows up as _
cat /proc/$pid of bash on term 1/attr/current is _



