Return-Path: <linux-kernel-owner+w=401wt.eu-S965888AbXD1Q2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888AbXD1Q2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965912AbXD1Q2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:28:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:3833 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965898AbXD1Q22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Dfo1/81X4M65THfB3zJ8dV2+/wLYTj0NuJkOeaEwb7mfMbzn0ZW2EDjARwh2qK+YOaNdAccTJrEAEruYITS5L8xpwQq6+5tCUCROSZ7wVL7/1mHfbmCi8mK0c85zQpQe5p2QdtVpXgPJMBP3Q+AzAx13VftNXosGLu1/5ZgQzkQ=
Message-ID: <463375E5.5040108@googlemail.com>
Date: Sat, 28 Apr 2007 18:27:17 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Riccardo Ricci <rricci@nuovanetmore.it>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Len Brown <len.brown@intel.com>, David Brownell <david-b@pacbell.net>,
       Jeff Mahoney <jeffm@suse.com>, reiserfs-dev@namesys.com,
       Jeff Chua <jeff.chua.linux@gmail.com>, Francois SIMOND <curio@free.fr>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org,
       =?UTF-8?B?SMOla2FuIExpbmRxdmlzdA==?= <lindqvist@netstar.se>,
       Vincent Frentzel <zcecc22@ucl.ac.uk>,
       =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= <francois.valenduc@skynet.be>,
       Thomas Meyer <thomas.mey@web.de>, Giorgio Lando <patroclo7@gmail.com>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: 2.6.21 known regressions (v2) (for -stable team)
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of known regressions reported after 2.6.21 release.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions


Subject    : kernel crash at boot with maxcpus=1 on quad core
             kernel BUG at drivers/cpufreq/cpufreq.c:1023
References : http://lkml.org/lkml/2007/4/27/460
Submitter  : Brandeburg, Jesse <jesse.brandeburg@intel.com>
Status     : Unknow

Subject    : Soft lockup on CPU0 when resuming from suspension to ram, related to acpi processor module
References : http://bugzilla.kernel.org/show_bug.cgi?id=8391
Submitter  : Giorgio Lando <patroclo7@gmail.com>
Status     : Unknow

Subject    : Bad interaction between dynticks and amarok?
References : http://lkml.org/lkml/2007/4/26/307
Submitter  : Thomas Meyer <thomas.mey@web.de>
Status     : Unknow

Subject    : Long pause initializating usb-storage
References : http://bugzilla.kernel.org/show_bug.cgi?id=8380
Submitter  : Vincent Frentzel <zcecc22@ucl.ac.uk>
Status     : Unknow

Subject    : Multpiple problem when thermal is loaded with kernel 2.6.21
References : http://bugzilla.kernel.org/show_bug.cgi?id=8385
Submitter  : François Valenduc <francois.valenduc@skynet.be>
Status     : Unknow

Subject    : 2.6.21: sky2 "hw csum failure" problem
References : http://lkml.org/lkml/2007/4/28/105
Submitter  : Håkan Lindqvist <lindqvist@netstar.se>
Status     : unknown

Subject    : sky2 regression in 2.6.21: Asus P5B-E Plus ethernet adapter no more supported  
References : http://lkml.org/lkml/2007/4/26/599
Submitter  : Francois SIMOND <curio@free.fr> 
Handled-By : Stephen Hemminger <shemminger@linux-foundation.org>
Status     : unknown

Subject    : 2.6.21 - BUG: at arch/i386/kernel/smp.c:177 send_IPI_mask_bitmask()
References : http://lkml.org/lkml/2007/4/27/621
Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown

Subject    : 2.6.21 don't boot, it stops after ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15).
References : http://lkml.org/lkml/2007/4/27/400
Submitter  : Riccardo Ricci < rricci@nuovanetmore.it >
Handled-By : Len Brown <lenb@kernel.org>
Status     : unknown

Subject    : ACPI interpreter errors
References : http://lkml.org/lkml/2007/4/27/206
Submitter  : Udo A. Steinberg < us15@os.inf.tu-dresden.de >
Handled-By : Len Brown <lenb@kernel.org>
Status     : unknown

Subject    : reiserfs -- circular locking
References : http://lkml.org/lkml/2007/4/26/648
Submitter  : David Brownell < david-b@pacbell.net >
Handled-By : Jeff Mahoney < jeffm@suse.com >
Patch      : http://lkml.org/lkml/2007/4/27/332
Status     : patch available

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
