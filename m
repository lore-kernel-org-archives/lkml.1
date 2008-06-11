Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYFKWv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYFKWv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYFKWvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:51:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:15773 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYFKWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sfK8bhEjNHcQxxebQESTDplApEtOfaJ0bWHBuPrFjnM4jc7QVgeb5QQWv+7sbvF7Ia
         uXkDTgdxTv3BMQK51CM9zwwch1YUdJSIiUE2T2Weui2I1a09ajPy8/iPjz/VO/IsSY3X
         EFBiyAIJxXYJX21nZ7HpsO2x2C5+1iOg1CEr0=
Message-ID: <4850570D.3060808@gmail.com>
Date: Thu, 12 Jun 2008 00:51:57 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: balbir@linux.vnet.ibm.com, menage@google.com, matt@bluehost.com,
       roberto@unbit.it, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
References: <1212791250-32320-2-git-send-email-righi.andrea@gmail.com> <20080611154228.ef269ff2.randy.dunlap@oracle.com>
In-Reply-To: <20080611154228.ef269ff2.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat,  7 Jun 2008 00:27:28 +0200 Andrea Righi wrote:
> 
>> Documentation of the block device I/O bandwidth controller: description, usage,
>> advantages and design.
>>
>> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
>> ---
>>  Documentation/controllers/io-throttle.txt |  150 +++++++++++++++++++++++++++++
>>  1 files changed, 150 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/controllers/io-throttle.txt
>>
>> diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
>> new file mode 100644
>> index 0000000..5373fa8
>> --- /dev/null
>> +++ b/Documentation/controllers/io-throttle.txt
>> @@ -0,0 +1,150 @@
>> +
>> +               Block device I/O bandwidth controller
>> +
>> +1. Description
>> +
>> +This controller allows to limit the I/O bandwidth of specific block devices for
>> +specific process containers (cgroups) imposing additional delays on I/O
>> +requests for those processes that exceed the limits defined in the control
>> +group filesystem.
>> +
>> +Bandwidth limiting rules offer better control over QoS with respect to priority
>> +or weight-based solutions that only give information about applications'
>> +relative performance requirements.
>> +
>> +The goal of the I/O bandwidth controller is to improve performance
>> +predictability and QoS of the different control groups sharing the same block
>> +devices.
>> +
>> +NOTE: if you're looking for a way to improve the overall throughput of the
>> +system probably you should use a different solution.
>> +
>> +2. User Interface
>> +
>> +A new I/O bandwidth limitation rule is described using the file
>> +blockio.bandwidth.
>> +
>> +The same file can be used to set multiple rules for different block devices
>> +relatively to the same cgroup.
> 
>    relative
> 

I will fix it in the next version.

Thanks again Randy.

-Andrea
