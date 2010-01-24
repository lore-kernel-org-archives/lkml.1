Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648Ab0AXWqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0AXWqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956Ab0AXWqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:46:36 -0500
Received: from smtp100.rog.mail.re2.yahoo.com ([206.190.36.78]:39735 "HELO
	smtp100.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754361Ab0AXWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:34:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ou3w50cp+fR5n4MAgQVgRJbFruj2+4Cui7cW+WMsFKhUkPn6y3b2H1cwX5rdhLZsWnMu+g3S1ImJztKlN6Il3/sDfYpjN+i6nHXtWizBKODg7dVnlVccT5sO+hdzSm5Xpruz6CMSj9hLqgAfewKSYHApfZAWyBxHc54BJVc0DIQ=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: WkUNUsIVM1nbfXiyORn4C2ueRfA88Zbae13wt_v5BB7CVbjtQ_Ne16JlmXJym6pL8w--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14859] System timer firing too much without cause
Date: Sun, 24 Jan 2010 17:34:50 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc5-custom-radeon; KDE/4.4.60; x86_64; svn-1073382; 2010-01-11)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.Z6G.gLMXLB@chimera>
In-Reply-To: <hE3x9c-4KZM.A.Z6G.gLMXLB@chimera>
MIME-Version: 1.0
Message-Id: <201001241734.50803.shawn.starr@rogers.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010 17:04:33 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14859
> Subject		: System timer firing too much without cause
> Submitter	: Shawn Starr <shawn.starr@rogers.com>
> Date		: 2009-12-21 19:16 (35 days old)

Continues with -rc5, I  really cannot use Dynamic ticks at all, it has to be 
disabled.

I should probably mention this CPU info:

processor       : 0                                                         
vendor_id       : GenuineIntel                                              
cpu family      : 6                                                         
model           : 23                                                        
model name      : Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz           
stepping        : 10                                                        
cpu MHz         : 800.000                                                   
cache size      : 6144 KB                                                   
physical id     : 0                                                         
siblings        : 2                                                         
core id         : 0                                                         
cpu cores       : 2                                                         
apicid          : 0                                                         
initial apicid  : 0                                                         
fpu             : yes                                                       
fpu_exception   : yes                                                       
cpuid level     : 13                                                        
wp              : yes                                                       
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor 
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida 
tpr_shadow vnmi flexpriority                                                                                                 
bogomips        : 5053.40                                                                                
clflush size    : 64                                                                                     
cache_alignment : 64                                                                                     
address sizes   : 36 bits physical, 48 bits virtual                                                      
power management:                                                                                        

