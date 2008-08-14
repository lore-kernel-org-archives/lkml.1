Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYHNJAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYHNJAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYHNI7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:59:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:6255 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYHNI7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CiUGTVCDhv+v5Ggf7RhSTmMaaFxaYLLz0W1YLysCH44cfJYQ6sgFJdZTCWWaBnUiRT
         XzTRMnDSH/+mzOeXbsMivvbUM0RZl7FUG7Sp0Zg16ZKO7I/0VOQus1AlOtDuJeFMe1pg
         aVMUA6ds2C08xuizxBIX8esnZAzMom3On/OmE=
Message-ID: <86802c440808140159n7874d343ncce1627de9463ac4@mail.gmail.com>
Date: Thu, 14 Aug 2008 01:59:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <b6a2187b0808140016m63c7d9d9s960014ec5cd9f3c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
	 <20080813141629.GD19397@elte.hu>
	 <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com>
	 <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com>
	 <20080813173940.GA32214@elte.hu>
	 <86802c440808131046s4df84ba9va12d45897cf6affa@mail.gmail.com>
	 <86802c440808131133o133e1dfftdfcc076a1100afb6@mail.gmail.com>
	 <b6a2187b0808140016m63c7d9d9s960014ec5cd9f3c5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 12:16 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Thu, Aug 14, 2008 at 2:33 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>>>>> > With 16 CPUs, it still hangs, but now the console is showing the
>>>>> > errors as intended.
>>>>> > ... but it is supposed to hang?
>
>> please check the attached patch. it should fix the new regression and
>> will not hang.
>
> Ok, booted up and not hanged, but those messages below don't show up
> anywhere. I've tested with CONFIG_NR_CPUS=16 and 8 as well. Just got 8
> cpus
>
> More than 8 CPUs detected - skipping them.
> Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
>
> # cat /sys/devices/system/cpu/possible
> 0-7
>
> CONFIG_X86_32=y
> CONFIG_X86_PC=y
>
>

double checked on one 16 cores system got

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(4) -> Core 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using C1E aware idle routine
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
Parsing all Control Methods:
Table [DSDT](id 0001) - 1289 Objects with 114 Devices 462 Methods 26 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 80 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
More than 8 CPUs detected - skipping them.
Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
enabled ExtINT on CPU#0

YH
