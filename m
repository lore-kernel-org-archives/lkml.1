Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbYF0OvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbYF0OvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbYF0OvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:51:07 -0400
Received: from hall.aurel32.net ([91.121.138.14]:41492 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbYF0OvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:51:06 -0400
Date: Fri, 27 Jun 2008 16:50:06 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: "Yang, Sheng" <sheng.yang@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: Add "virt flag" in /proc/cpuinfo
Message-ID: <20080627145006.GA10707@volta.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	"Yang, Sheng" <sheng.yang@intel.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <200806241708.49462.sheng.yang@intel.com> <48645DD7.5090503@goop.org> <200806271131.38540.sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200806271131.38540.sheng.yang@intel.com>
X-Mailer: Mutt 1.5.18 (2008-05-17)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 11:31:38AM +0800, Yang, Sheng wrote:
> On Friday 27 June 2008 11:26:15 Jeremy Fitzhardinge wrote:
> > Yang, Sheng wrote:
> > > From 54b1bb9fe5d2fe40fc047b43dd4e1a480d41a977 Mon Sep 17 00:00:00
> > > 2001 From: Sheng Yang <sheng.yang@intel.com>
> > > Date: Tue, 24 Jun 2008 17:03:17 +0800
> > > Subject: [PATCH] x86: Add "virt flag" in /proc/cpuinfo
> > >
> > > The hardware virtualization technology evolves very fast. But
> > > currently it's hard to tell if your CPU support a certain kind of
> > > HW technology without dig into the source code.
> > >
> > > The patch add a new item under /proc/cpuinfo, named "virt flag".
> > > The "virt flag" got the similar function as "flag". It is used to
> > > indicate what features does this CPU supported. It don't cover
> > > all features but only the important ones.
> >
> > A cpu feature is a cpu feature.  I'd prefer to see all this in
> > "flags:".
> >
> >     J
> 
> But I think (as I said before)
> 
> 1. The standard flag covered upper level of cpu capability, they are 
> covered by CPUID. And virt flag was enabled by vmx/svm (we can leave 
> it blank also), and covered by MSR. It's very different.
> 
> 2. If we add virtual feature to standard flag, I am afraid it would 
> grow too fast, though we just add some key feature to it.
> 

What about dumping the virtualisation flags to the kernel log when the
vmx/svm module is loaded?

Also do we have an idea of the number of flags that would appear on a
current CPU?

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
