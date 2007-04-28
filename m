Return-Path: <linux-kernel-owner+w=401wt.eu-S1031545AbXD1Qw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031545AbXD1Qw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031556AbXD1Qw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:52:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:41399 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031545AbXD1QwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GXPTL8dpeo1U5lvfWjkwB3zFEj+r/HvP4eURXnLXoPc4YF2wqmtUVBtKF+u9jOUCbdSlz0XWCUS+Tr7+RFlRs8suxpadH3oftp6ZQ+V9559jUvIWAhPhVgZVrdEsGHO3fG7slL6iuedKJbCF8ZFJHKdzfjfMOFmWOTUDsA2yRU4=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
Date: Sat, 28 Apr 2007 12:52:19 -0400
User-Agent: KMail/1.9.6
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Riccardo Ricci <rricci@nuovanetmore.it>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Len Brown <len.brown@intel.com>, David Brownell <david-b@pacbell.net>,
       Jeff Mahoney <jeffm@suse.com>, reiserfs-dev@namesys.com,
       Jeff Chua <jeff.chua.linux@gmail.com>, Francois SIMOND <curio@free.fr>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org,
       =?utf-8?q?H=C3=A5kan_Lindqvist?= <lindqvist@netstar.se>,
       Vincent Frentzel <zcecc22@ucl.ac.uk>,
       =?utf-8?q?Fran=C3=A7ois_Valenduc?= <francois.valenduc@skynet.be>,
       Thomas Meyer <thomas.mey@web.de>, Giorgio Lando <patroclo7@gmail.com>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
References: <463375E5.5040108@googlemail.com>
In-Reply-To: <463375E5.5040108@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704281252.20381.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 April 2007, Michal Piotrowski wrote:
>Hi all,
>
>Here is a list of known regressions reported after 2.6.21 release.
>
>Feel free to add new regressions/remove fixed etc.
>http://kernelnewbies.org/known_regressions
>
I went here, but without a login the page is immutable

Therefore I'll add it here

Subject		:proprietary belkin upsd turns into cpu hog
Submitter	:gene.heskett@gmail.com
Reference	:something changed in how /dev/ttyUSB's handle 1 and 2 byte messages 
from pl2303 usb<->serial adaptors.  Also, assignation of ttyUSB#'s is 
volatile depending on phase of the moon when booted.

>
>Subject    : kernel crash at boot with maxcpus=1 on quad core
>             kernel BUG at drivers/cpufreq/cpufreq.c:1023
>References : http://lkml.org/lkml/2007/4/27/460
>Submitter  : Brandeburg, Jesse <jesse.brandeburg@intel.com>
>Status     : Unknow
>
>Subject    : Soft lockup on CPU0 when resuming from suspension to ram,
> related to acpi processor module References :
> http://bugzilla.kernel.org/show_bug.cgi?id=8391
>Submitter  : Giorgio Lando <patroclo7@gmail.com>
>Status     : Unknow
>
>Subject    : Bad interaction between dynticks and amarok?
>References : http://lkml.org/lkml/2007/4/26/307
>Submitter  : Thomas Meyer <thomas.mey@web.de>
>Status     : Unknow
>
>Subject    : Long pause initializating usb-storage
>References : http://bugzilla.kernel.org/show_bug.cgi?id=8380
>Submitter  : Vincent Frentzel <zcecc22@ucl.ac.uk>
>Status     : Unknow
>
>Subject    : Multpiple problem when thermal is loaded with kernel 2.6.21
>References : http://bugzilla.kernel.org/show_bug.cgi?id=8385
>Submitter  : François Valenduc <francois.valenduc@skynet.be>
>Status     : Unknow
>
>Subject    : 2.6.21: sky2 "hw csum failure" problem
>References : http://lkml.org/lkml/2007/4/28/105
>Submitter  : Håkan Lindqvist <lindqvist@netstar.se>
>Status     : unknown
>
>Subject    : sky2 regression in 2.6.21: Asus P5B-E Plus ethernet adapter no
> more supported References : http://lkml.org/lkml/2007/4/26/599
>Submitter  : Francois SIMOND <curio@free.fr>
>Handled-By : Stephen Hemminger <shemminger@linux-foundation.org>
>Status     : unknown
>
>Subject    : 2.6.21 - BUG: at arch/i386/kernel/smp.c:177
> send_IPI_mask_bitmask() References : http://lkml.org/lkml/2007/4/27/621
>Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
>Status     : unknown
>
>Subject    : 2.6.21 don't boot, it stops after ACPI: PCI Interrupt Link
> [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15). References :
> http://lkml.org/lkml/2007/4/27/400
>Submitter  : Riccardo Ricci < rricci@nuovanetmore.it >
>Handled-By : Len Brown <lenb@kernel.org>
>Status     : unknown
>
>Subject    : ACPI interpreter errors
>References : http://lkml.org/lkml/2007/4/27/206
>Submitter  : Udo A. Steinberg < us15@os.inf.tu-dresden.de >
>Handled-By : Len Brown <lenb@kernel.org>
>Status     : unknown
>
>Subject    : reiserfs -- circular locking
>References : http://lkml.org/lkml/2007/4/26/648
>Submitter  : David Brownell < david-b@pacbell.net >
>Handled-By : Jeff Mahoney < jeffm@suse.com >
>Patch      : http://lkml.org/lkml/2007/4/27/332
>Status     : patch available
>
>Regards,
>Michal



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Love is a grave mental disease.
		-- Plato
