Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZBWS1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZBWS1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZBWS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:27:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:38591 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZBWS1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kNaQJlzvH6tpAH0xNHicYMpI2HgVHs7L3ervS9O1GzxnnFqFDanpJZsEm72z8woQzK
         ITF2SFLIS4XQ0+6MXGZz2rpQTQkcazar0CkeYxzp2pahI9kMKvwulukmNQVLLelR6yWh
         /nq29jfgRNRBQAnEVZO+6Jk5UoUksq/RHwXu4=
MIME-Version: 1.0
In-Reply-To: <20090223152225.GA12909@silver.sucs.org>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
	 <20090223152225.GA12909@silver.sucs.org>
Date: Mon, 23 Feb 2009 19:27:09 +0100
Message-ID: <8db1092f0902231027k49b88f68o9ac999399a368777@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not 
	ioremap virtual address for G33 hw status page
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, rui.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/23 Sitsofe Wheeler <sitsofe@yahoo.com>:
> On Mon, Feb 23, 2009 at 03:46:41PM +0100, Maciej Rutecki wrote:
>> 2.6.29-rc5 and 2.6.29-rc5-git6 work OK. In 2.6.29-rc6 XWindow (KDM)
>> doesn't start, from dmesg:
>>
>> [   18.170614] [drm] Initialized drm 1.1.0 20060810
>> [   18.247445] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> [   18.247455] pci 0000:00:02.0: setting latency timer to 64
>> [   18.249610] mtrr: type mismatch for d0000000,10000000 old:
>> write-back new: write-combining
>> [   18.249621] [drm] MTRR allocation failed
>> [   18.249622] .  Graphics performance may suffer.
>
> Does enabling mtrr cleanup as described on
> http://marc.info/?l=linux-kernel&m=123501581629566&w=2 help?
>

It doesn't help

maciek@zlom:~$ cat /boot/config-2.6.29-rc6 | grep MTRR
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

Still the same errors.
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
