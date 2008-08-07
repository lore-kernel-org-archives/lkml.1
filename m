Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYHGUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYHGUXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYHGUXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:23:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:55097 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHGUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aSs+UJcpvrEBQdKGHK5sF4XDn69AZdm7yfNriDM1el9CJ3QtHooKrPP1G5swXYZbTk
         EVISfLo4fRJFe25+8fvrErKuyWze437/wDv/hOiZ6vKiuaXB9WQAF2EtLg5a69GXYQys
         XBumSOlNEbtTt3jkyUQDnJm2M/z9JNJUYUTRA=
Message-ID: <86802c440808071323o3021a90rae51223187bfd47b@mail.gmail.com>
Date: Thu, 7 Aug 2008 13:23:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.27-rc1 mtrr fixes do not work
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexander Huemer" <alexander.huemer@sbg.ac.at>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46092119D3@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at> <200808072214.28922.rjw@sisk.pl>
	 <7E82351C108FA840AB1866AC776AEC46092119D3@orsmsx505.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 1:15 PM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
>
> Adding Yinghai.
>
>>-----Original Message-----
>>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>>Sent: Thursday, August 07, 2008 1:14 PM
>>To: Alexander Huemer
>>Cc: linux-kernel@vger.kernel.org; Andi Kleen; Pallipadi, Venkatesh
>>Subject: Re: 2.6.27-rc1 mtrr fixes do not work
>>
>>[Adding CCs.]
>>
>>On Wednesday, 6 of August 2008, Alexander Huemer wrote:
>>> hi,
>>>
>>> mtrr is wrong on my machine. the fixes of 2.6.27-rc1 do not
>>seem to work.
>>> bios is the newest version, mainboard vendor says it's not
>>their fault.
>>> mainboard is tyan i5000pw.
>>> please tell me how i can help and cc me on answers, i am not
>>subscribed.
>>>
>>> seaburg ~ # cat /proc/mtrr
>>> reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
>>> reg01: base=0x80000000 (2048MB), size=197632MB: write-back, count=1
>>> reg02: base=0x100000000 (4096MB), size=197632MB: write-back, count=1

>>>
>>> seaburg ~ # zcat /proc/config.gz | grep MTRR
>>> CONFIG_MTRR=y
>>> CONFIG_MTRR_SANITIZER=y
>>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>> seaburg ~ # uname -a
>>> Linux seaburg 2.6.27-rc1-blackbit #3 SMP Wed Aug 6 00:34:51 CEST 2008
>>> x86_64 Intel(R) Xeon(R) CPU E5420 @ 2.50GHz GenuineIntel GNU/Linux
>>> seaburg ~ #

alexander,

please send out
dmesg -s 262144 > dmesg.txt
or
dmesg -s 524288 > dmesg.txt

you may need to set
CONFIG_LOG_BUF_SHIFT=19

YH
