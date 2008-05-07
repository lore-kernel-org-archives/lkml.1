Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYEGGTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYEGGTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYEGGTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:19:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbYEGGTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:19:05 -0400
Date: Tue, 6 May 2008 23:18:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tockar <tockar@o2.pl>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: Problem with sensors on linux 2.6.25
Message-Id: <20080506231838.563c9dcd.akpm@linux-foundation.org>
In-Reply-To: <200805042334.03574.tockar@o2.pl>
References: <200805042334.03574.tockar@o2.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 23:34:03 +0200 tockar <tockar@o2.pl> wrote:

> Hello,
> I've strange problem with Linux 2.6.25 and later (I've compiled 2.6.26-rc1 and 
> I have same problem). In 'sensors' command result, I get ALARMs. 
> Here's 'sensors' result on Linux 2.6.24:
> 
> it87-isa-0290
> Adapter: ISA adapter
> VCore 1:     +1,71 V  (min =  +3,97 V, max =  +1,95 V)
> VCore 2:     +3,09 V  (min =  +3,82 V, max =  +1,01 V)
> +3.3V:       +3,07 V  (min =  +3,82 V, max =  +3,06 V)
> +5V:         +5,59 V  (min =  +4,27 V, max =  +5,11 V)
> +12V:       +13,31 V  (min = +15,62 V, max =  +7,74 V)
> -12V:        -2,69 V  (min =  -0,61 V, max =  +3,44 V)
> -5V:         -9,14 V  (min =  +3,82 V, max =  -2,62 V)
> Stdby:       +0,00 V  (min =  +6,37 V, max =  +5,03 V)
> VBat:        +3,25 V
> fan1:       5152 RPM  (min =    0 RPM, div = 2)
> fan2:          0 RPM  (min =    0 RPM, div = 2)
> M/B Temp:    +34,0__C  (low  =  -7,0__C, high = -11,0__C)  sensor = transistor
> CPU Temp:    +33,0__C  (low  = -66,0__C, high = +127,0__C)  sensor = transistor
> Temp3:       +31,0__C  (low  = -33,0__C, high = -101,0__C)  sensor = transistor
> 
> Two minutes later, on Linux 2.6.25:
> 
> it87-isa-0290
> Adapter: ISA adapter
> VCore 1:     +1,71 V  (min =  +3,97 V, max =  +1,95 V)   ALARM
> VCore 2:     +3,09 V  (min =  +3,82 V, max =  +1,01 V)   ALARM
> +3.3V:       +3,07 V  (min =  +3,82 V, max =  +3,06 V)   ALARM
> +5V:         +5,59 V  (min =  +4,27 V, max =  +5,11 V)   ALARM
> +12V:       +13,31 V  (min = +15,62 V, max =  +7,74 V)   ALARM
> -12V:        -2,69 V  (min =  -0,61 V, max =  +3,44 V)   ALARM
> -5V:         -9,14 V  (min =  +3,82 V, max =  -2,62 V)   ALARM
> Stdby:       +0,00 V  (min =  +6,37 V, max =  +5,03 V)   ALARM
> VBat:        +3,25 V
> fan1:       5152 RPM  (min =    0 RPM, div = 2)
> fan2:          0 RPM  (min =    0 RPM, div = 2)
> M/B Temp:    +35,0__C  (low  =  -7,0__C, high = -11,0__C)  sensor = transistor
> CPU Temp:    +33,0__C  (low  = -66,0__C, high = +127,0__C)  sensor = transistor
> Temp3:       +32,0__C  (low  = -33,0__C, high = -101,0__C)  sensor = transistor
> 
> Results are almost identical, but I get those ALARMs. I've Pentium4 1,4Ghz 
> processor, module for my mainboard is BLK_DEV_VIA82CXXX. Is that a bug? Can I 
> safely use Linux 2.6.25 or later?

(cc added)
