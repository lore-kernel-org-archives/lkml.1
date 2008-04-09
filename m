Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYDIUFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYDIUFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYDIUFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:05:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:33314 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYDIUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LTRWrpNBnrIRPoB3rhVuO9oSKEQLB02/VgACB9XUqvYPL5EbXAWX/Opqu9pqlExxoN504lz8ncX1xeccJbsEA0hnGPFR+Qe6B9AJGVmJk6N6HrrPAFkjmfyJnAGi+zTOnG8MdX9T7Upo16Wsu0nQeN7MEXYN94PujBCmXUlxfM4=
Message-ID: <cf40c6a90804091305i455518d5iaaf5ca9f552c89f2@mail.gmail.com>
Date: Wed, 9 Apr 2008 22:05:07 +0200
From: "Andreas Grimm" <agrimm61@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: VM - a plenty of inactive memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87myo2redk.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	 <874pabrx6b.fsf@saeurebad.de>
	 <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
	 <2f11576a0804090801s49587b26h115e8e1760ec7671@mail.gmail.com>
	 <cf40c6a90804091108v522bd757nb81e9f97fdc132fc@mail.gmail.com>
	 <87myo2redk.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johnannes,

of course:
MemTotal:     33265916 kB
MemFree:        438764 kB
Buffers:         98544 kB
Cached:        1837180 kB
SwapCached:          0 kB
Active:        7086300 kB
Inactive:     25168628 kB
HighTotal:    32631216 kB
HighFree:       429252 kB
LowTotal:       634700 kB
LowFree:          9512 kB
SwapTotal:     2104504 kB
SwapFree:      2104504 kB
Dirty:           14480 kB
Writeback:           0 kB
Mapped:         515524 kB
Slab:           506636 kB
CommitLimit:  18737460 kB
Committed_AS: 16388640 kB
PageTables:      37036 kB
VmallocTotal:   112632 kB
VmallocUsed:     15024 kB
VmallocChunk:    95268 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     2048 kB

Here the meminfo from a "normal" system, nearly same amount of users,
and stress, but only 16GB of ram:

MemTotal:     16619808 kB
MemFree:       5497672 kB
Buffers:        422592 kB
Cached:        7018072 kB
SwapCached:          0 kB
Active:        8769608 kB
Inactive:      1979508 kB
HighTotal:    15854036 kB
HighFree:      5484136 kB
LowTotal:       765772 kB
LowFree:         13536 kB
SwapTotal:     4200988 kB
SwapFree:      4200828 kB
Dirty:           16956 kB
Writeback:           0 kB
Mapped:         864284 kB
Slab:           309456 kB
CommitLimit:  12510892 kB
Committed_AS: 14933584 kB
PageTables:      33248 kB
VmallocTotal:   112632 kB
VmallocUsed:      9980 kB
VmallocChunk:   102480 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     2048 kB

Thanks,
Andreas

2008/4/9, Johannes Weiner <hannes@saeurebad.de>:
> Hi,
>
>  "Andreas Grimm" <agrimm61@gmail.com> writes:
>
>
> > Hi Kosaki,
>  >
>  >>  # echo 3 > /proc/sys/vm/drop_caches
>  >>
>  > that frees exactly the 1,5Gigs in the buffers and the cache. Inactive
>  > memory is still at 25GB.
>  > Any other hint?
>
>
> Could you supply the rest of /proc/meminfo?
>
>         Hannes
>
