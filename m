Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZFEHAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZFEHAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZFEHAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:00:00 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:38820 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZFEG77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:59:59 -0400
Message-ID: <4A28C262.5020605@oracle.com>
Date: Fri, 05 Jun 2009 14:59:46 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
 2.6.30-rc8.
References: <4A289928.7040508@oracle.com> <20090604223805.2962e826.akpm@linux-foundation.org>
In-Reply-To: <20090604223805.2962e826.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A28C266.012B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Fri, 05 Jun 2009 12:03:52 +0800 Tao Ma <tao.ma@oracle.com> wrote:
> 
>> Hi list,
>>        In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable large 
>> to be 281474974617600.
>> While in a x86 box, it is 931131392 which looks sane.
>>
>> [root@test8 ~]# ll /proc/kcore
>> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
>>
>> [root@ocfs2-test9 ~]$ ll /proc/kcore
>> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore
>>
>> I just noticed this when kexec fails in "Can't find kernel text map area 
>> from kcore".
>>
>> Is there something wrong?
>>
> 
> fs/proc/kcore.c hasn't changed since October last year.  Was 2.6.29 OK?
> Earlier kernels?
with 2.6.29, ls shows the same output.
[root@test8 ~]# ll /proc/kcore
-r-------- 1 root root 281474974617600 Jun  5 14:35 /proc/kcore

But the kexec works.

I just checked .28, the same as .29.

Regards,
Tao
