Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYCZE3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYCZE3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYCZE3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:29:30 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:49431 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYCZE33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:29:29 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Why /proc/cpuinfo doesn't print L1,L2,L3 caches?
To: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 26 Mar 2008 07:29:26 +0300
References: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com> <47E97566.5020003@redhat.com>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20080326042927.CAF0EA30719@smtp05.mtu.ru>
X-DCC-STREAM-Metrics: smtp05.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> 
> /sys/devices/system/cpu/cpu0/cache
> 

I do not have it:

{pts/1}% uname -a
Linux cooker 2.6.25-rc6-1avb #11 Fri Mar 21 20:47:27 MSK 2008 i686 Pentium
III (Coppermine) GNU/Linux
{pts/1}% l /sys/devices/system/cpu/cpu0
cpuidle/
{pts/1}% cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 10
cpu MHz         : 747.749
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov
pat pse36 mmx fxsr sse
bogomips        : 1499.05
clflush size    : 32


What am I missing?

