Return-Path: <linux-kernel-owner+w=401wt.eu-S934708AbZJJA5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934708AbZJJA5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZJJA5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:57:11 -0400
Received: from nskntmtas02p.mx.bigpond.com ([61.9.168.140]:63099 "EHLO
	nskntmtas02p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757184AbZJJA5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:57:10 -0400
Message-ID: <4ACFDBBA.4040709@bigpond.net.au>
Date: Sat, 10 Oct 2009 10:56:26 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: ykzhao <yakui.zhao@intel.com>
CC: Dave Airlie <airlied@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ERROR] drm:edid;  Unexpected error messages in syslog
References: <4ACAE592.8030307@bigpond.net.au> <1255065468.3601.24.camel@localhost.localdomain>
In-Reply-To: <1255065468.3601.24.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nskntotgx02p.mx.bigpond.com from [124.186.77.165] using ID pwil3058@bigpond.net.au at Sat, 10 Oct 2009 00:56:27 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150201.4ACFDBBB.00C6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/09 15:17, ykzhao wrote:
> On Tue, 2009-10-06 at 14:37 +0800, Peter Williams wrote:
>> I've started getting the following messages on recent kernels:
>>
>> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:50:40 mudlark kernel:
>> Oct  5 16:50:40 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
>> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:50:40 mudlark kernel:
>> Oct  5 16:50:40 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
>> Oct  5 16:50:41 mudlark kernel: [drm] DAC-6: set mode 1600x1200 16
>> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:50:45 mudlark kernel:
>> Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
>> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:50:45 mudlark kernel:
>> Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
>> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:50:45 mudlark kernel:
>> Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
>> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:51:00 mudlark kernel:
>> Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
>> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:51:00 mudlark kernel:
>> Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
>> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID
>> checksum is invalid, remainder is 16
>> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
>> Oct  5 16:51:00 mudlark kernel:
>> Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> It seems that the EDID obtained from VGA monitor is incorrect.
> Will you please open a new bug in
> https://bugs.freedesktop.org/
>
> and attach the output of dmesg, vbios.dump?
> The vbios.dump can be obtained by using the following commands:
>      echo 1>  /sys/devices/pci0000:00/0000:00:02.0/rom
>      cat /sys/devices/pci0000:00/0000:00:02.0/rom>  vbios.dump
>      echo 0>  /sys/devices/pci0000:00/0000:00:02.0/rom
>
> Thanks.

Exactly which of the MANY products at this site should be the target of 
this bug report?  It's certainly not obvious to me :-(.

>>
>> Should I worry about these?  There's no other noticeable problem with
>> the system.
>>
>> Peter
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
