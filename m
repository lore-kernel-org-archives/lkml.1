Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbZBMUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbZBMUmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZBMUmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:42:46 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:59111 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZBMUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:42:45 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
Date: Fri, 13 Feb 2009 21:43:08 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.10-phiphi; KDE/4.2.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <alpine.LFD.2.00.0902131356010.5440@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902131356010.5440@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902132143.08471.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 19:56:54 Len Brown wrote:
> dmesg -- assuming you can boot far enough to capture it,
> may be helpful.
>
> also, disabling PREEMPT may be interesting to try.
>
> cheers,
> --
> Len Brown, Intel Open Source Technology Center

difference between the two /proc/cpuinfos shows this : 
especially "cpu cores" and "cpuid level" are quite different : does this may be 
some hint ?


--- proc_cpuinfo_2.6.27.10      2009-02-13 21:28:09.000000000 +0100
+++ proc_cpuinfo_2.6.29-rc4_test1       2009-02-13 21:28:00.000000000 +0100
@@ -4,20 +4,20 @@                                                          
 model          : 23                                                       
 model name     : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz          
 stepping       : 10                                                       
-cpu MHz                : 2999.632                                         
+cpu MHz                : 2999.773                                         
 cache size     : 6144 KB                                                  
 physical id    : 0                                                        
 siblings       : 2                                                        
 core id                : 0                                                
-cpu cores      : 1                                                        
+cpu cores      : 2
 apicid         : 0
 initial apicid : 0
 fpu            : yes
 fpu_exception  : yes
-cpuid level    : 2
+cpuid level    : 13
 wp             : yes
-flags          : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr s
se sse2 ss ht tm pbe syscall nx lm constant_tsc pebs bts rep_good nopl pni 
monitor ds_cpl vmx smx est tm2 ssse3 cx16
xtpr sse4_1 lahf_lm
-bogomips       : 5999.26
+flags          : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr s
se sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good 
pni dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexpriority
+bogomips       : 5999.54
 clflush size   : 64
 cache_alignment        : 64
 address sizes  : 36 bits physical, 48 bits virtual
@@ -29,20 +29,20 @@
 model          : 23
 model name     : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
 stepping       : 10
-cpu MHz                : 2999.632
+cpu MHz                : 2999.773
 cache size     : 6144 KB
 physical id    : 0
 siblings       : 2
-core id                : 0
-cpu cores      : 1
+core id                : 1
+cpu cores      : 2
 apicid         : 1
 initial apicid : 1
 fpu            : yes
 fpu_exception  : yes
-cpuid level    : 2
+cpuid level    : 13
 wp             : yes
-flags          : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr s
se sse2 ss ht tm pbe syscall nx lm constant_tsc pebs bts rep_good nopl pni 
monitor ds_cpl vmx smx est tm2 ssse3 cx16
xtpr sse4_1 lahf_lm
-bogomips       : 8398.69
+flags          : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr s
se sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good 
pni dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexpriority
+bogomips       : 5999.07
 clflush size   : 64
 cache_alignment        : 64
 address sizes  : 36 bits physical, 48 bits virtual

