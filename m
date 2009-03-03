Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZCCOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZCCOvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZCCOvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:51:05 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50517 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZCCOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:51:03 -0500
Date: Tue, 3 Mar 2009 14:50:40 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [TIP,regression,i915] /dev/dri/card0 is no longer present
Message-ID: <20090303145040.GA7979@silver.sucs.org>
References: <20090301110455.GA18547@silver.sucs.org> <20090301113948.GA3602@elte.hu> <20090301134809.GA4753@silver.sucs.org> <1236020758.4586.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236020758.4586.76.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 11:05:58AM -0800, Pallipadi, Venkatesh wrote:
> On Sun, 2009-03-01 at 05:48 -0800, Sitsofe Wheeler wrote:
> > On Sun, Mar 01, 2009 at 12:39:48PM +0100, Ingo Molnar wrote:
> > >
> > > Thanks, i've reverted the commit for now. Could you please send
> > > a 'dmesg' from the bootup with the failed driver? By all
> > > likelyhood an ioremap failure causes a driver failure.
> > >
> > 
> > See below (drm says it initalized though...):
> > 
> > [    0.000000] Linux version 2.6.29-rc6-00006-g17581ad (@verona) (gcc version 4.2.4) #87 Sun Mar 1 13:42:28 GMT 2009
> > [    0.000000] KERNEL supported cpus:
> > [    0.000000]   Intel GenuineIntel
> > [    0.000000] PAT WC disabled due to known CPU erratum.
> 
> Looks like PAT is getting disabled on this platform. Can you send the
> output of /proc/cpuinfo please.

The machine has a stepping of the Celeron M chip in it with PAT errata.
I think it becomes disabled  because it would require a careful code to
ensure that WC was only used in circumstances where the errata would not
matter...

Here's the contents of /proc/cpuinfo:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Celeron(R) M processor          900MHz
stepping	: 8
cpu MHz		: 900.074
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx bts
bogomips	: 1800.14
clflush size	: 64
power management:

-- 
Sitsofe | http://sucs.org/~sits/
