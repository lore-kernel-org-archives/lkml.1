Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZHYGAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZHYGAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZHYGAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:00:53 -0400
Received: from mail192.messagelabs.com ([216.82.241.243]:52692 "HELO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752419AbZHYGAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:00:52 -0400
X-VirusChecked: Checked
X-Env-Sender: Haneef.Syed@lntinfotech.com
X-Msg-Ref: server-15.tower-192.messagelabs.com!1251180050!18314785!3
X-StarScan-Version: 6.1.3; banners=lntinfotech.com,-,-
X-Originating-IP: [203.101.96.4]
To: kvm-owner@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>
Subject: IBM server-X3650 issue with kvm modules
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OFB13FCF1E.D85554FA-ON6525761D.00201C5A-6525761D.002108B9@lntinfotech.com>
From: Haneef Syed <Haneef.Syed@lntinfotech.com>
Date: Tue, 25 Aug 2009 11:30:50 +0530
X-MIMETrack: Serialize by Router on BANGALORE/LNTINFOTECH(Release 7.0.3|September 26, 2007) at
 08/25/2009 11:30:51 AM,
	Serialize complete at 08/25/2009 11:30:51 AM,
	Itemize by SMTP Server on BangaloreSMTP/LNTINFOTECH(Release 7.0.3|September
 26, 2007) at 08/25/2009 11:32:21 AM,
	Serialize by Router on BangaloreSMTP/LNTINFOTECH(Release 7.0.3|September 26, 2007) at
 08/25/2009 11:32:24 AM,
	Serialize complete at 08/25/2009 11:32:24 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

Presently I m porting kvm-76 modules on IBM server x3650 target. 

System Information:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz
stepping        : 6
cpu MHz         : 2327.501
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm 
constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 4658.35
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

Thanks for patient..

when i run qemu utilities to install redhat or fedora guest on montavista 
host running in ibm server, i found that there is vmwrite error occurs on 
following 

registers 

GUEST_RFLAGS = 0x00006820
TPR_THRESHOLD  = 0x0000401c
CPU_BASED_VM_EXEC_CONTROL= 0x00004002
GUEST_RSP = 0x0000681c
GUEST_RIP  = 0x0000681e
HOST_CR0= 0x00006c00

And then kvm-76 aborted.. Any help will be appreciated.. Thanks in 
advance..



______________________________________________________________________
