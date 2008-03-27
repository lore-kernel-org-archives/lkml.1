Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbYC0VoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbYC0VoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYC0Vnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:43:55 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:49223 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbYC0Vny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:43:54 -0400
Date: Thu, 27 Mar 2008 22:43:52 +0100
Message-Id: <215201015@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?iso-8859-15?Q?Re:_acpi=5Fps=5Fexecute=5Fmethod_OOPS_(Re:_some_minor_?=
 =?iso-8859-15?Q?issues_with_2.6.25-rc6-git7-default)?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+SsNiDuU/GziPX1IqxiwaJ8WoPR506VlU1e+361XAi/3Sls
 uXASCCvrcWyYLpparQzavj5C1XJDhn36Z5HbksfLopUv21/zQs=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What CPU/chipset is this?

opensuse103:~ # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.80GHz
stepping        : 8
cpu MHz         : 1798.691
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss up pebs bts
bogomips        : 3627.10
clflush size    : 64

opensuse103:~ # lspci
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 01)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 01)
00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 08)
00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB
00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 08)
00:0f.0 VGA compatible controller: VMware Inc Abstract SVGA II Adapter
00:10.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 01)
00:11.0 PCI bridge: VMware Inc Unknown device 0790 (rev 02)
02:00.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 10)


to make sure that you didn`t miss my last post - i already found a possible correlation:

>i searched into this and found that it only happens after modprobe netsc520 ;modprobe -r netsc520.
>so maybe this is no acpi problem at all but corruption (sort of?) introduced by netsc520 module !?

regards
roland



> -----Ursprüngliche Nachricht-----
> Von: "Rafael J. Wysocki" <rjw@sisk.pl>
> Gesendet: 27.03.08 22:09:28
> An: devzero@web.de
> CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
> Betreff: Re: acpi_ps_execute_method OOPS (Re: some minor issues with 2.6.25-rc6-git7-default)


> 
> On Thursday, 27 of March 2008, devzero@web.de wrote:
> > > On Tuesday 25 March 2008, devzero@web.de wrote:
> > > ...
> > > > this one looks more serious (happened with modprobe -r ac),
> > > > because kernel has problems afterwards (cannot load/anload any other module afterwards) 
> > > 
> > > any idea when this started happening?
> > > Any chance you can snag the output from acpidump
> > > and attach it to a sighting here?:
> > > http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> > > 
> > > thanks,
> > > -Len
> > 
> > i searched into this and found that it only happens after modprobe netsc520 ;modprobe -r netsc520.
> > so maybe this is no acpi problem at all but corruption (sort of?) introduced by netsc520 module !?
> 
> What CPU/chipset is this?
> 
> Rafael
> 


_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

