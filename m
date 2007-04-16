Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXDPJYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXDPJYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030250AbXDPJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:24:06 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:29784 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030258AbXDPJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:24:05 -0400
Message-ID: <462340B4.2000300@ru.mvista.com>
Date: Mon, 16 Apr 2007 13:24:04 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       davidsen@tmr.com, randy.dunlap@oracle.com, dada1@cosmosbay.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
References: <461A4C1E.3070309@ru.mvista.com> <20070415094706.GB10097@ucw.cz> <20070415102157.GB2986@holomorphy.com> <20070415201024.GB12012@ucw.cz> <20070416010424.GG2986@holomorphy.com>
In-Reply-To: <20070416010424.GG2986@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:

>On Sun 2007-04-15 03:21:57, William Lee Irwin III wrote:
>  
>
>>>nvcsw and nivcsw are conventional variable names for these quantities.
>>>      
>>>
>
>On Sun, Apr 15, 2007 at 08:10:24PM +0000, Pavel Machek wrote:
>  
>
>>I can't decipher them and would not want users see them in /proc.
>>Would nonvoluntary_ctxt_switch be that much worse?
>>    
>>
>
>I'm not too attached to a particular name. I just think that the
>traditional counter names should pass readability/etc. criteria on
>account of the very strong historical precedent. I'd consider more
>verbose affairs for the sake of putative legibility as equivalent
>in quality. Maybe that means others voting for the more verbose
>names should result in an aggregate decision in favor of verbosity.
>
>
>-- wli
>  
>
The standard /proc output is:
root@192.168.3.2:~# cat /proc/$$/status
Name:   bash
State:  S (sleeping)
SleepAVG:       88%
Tgid:   836
Pid:    836
PPid:   1
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 256
Groups: 0 1 2 4
VmPeak:     2360 kB
VmSize:     2360 kB
VmLck:         0 kB
VmHWM:      1400 kB
VmRSS:      1400 kB
VmData:      196 kB
VmStk:        88 kB
VmExe:       564 kB
VmLib:      1412 kB
VmPTE:        12 kB
Threads:        1
SigQ:   0/1024
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000010000
SigIgn: 0000000000384004
SigCgt: 000000004b813efb
CapInh: 0000000000000000
CapPrm: 00000000fffffeff
CapEff: 00000000fffffeff

I can't say that "Nvcsw" and "Nivcsw" is something less verbose as 
output above.
It is more usual  so it is more clear for you. But if you need this counters
you should know what are they and how to use them.

As for me "nonvoluntary_ctxt_switch" and "voluntary_ctxt_switch" is more 
verbose,
and it is not big deal to change names. But I think that information about
this counters and verbose name should be in user space tools, like ps.


