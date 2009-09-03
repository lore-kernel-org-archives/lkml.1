Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbZICWCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbZICWCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZICWCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:02:52 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:49557 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbZICWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:02:52 -0400
Date: Fri, 4 Sep 2009 00:02:52 +0200
From: Bastian Blank <waldi@debian.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       544145@bugs.debian.org, Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
Message-ID: <20090903220252.GA19309@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
	xen-devel@lists.xensource.com, 544145@bugs.debian.org,
	Keir Fraser <keir.fraser@eu.citrix.com>
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AA02C57.30106@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 01:51:35PM -0700, Jeremy Fitzhardinge wrote:
> On 08/30/09 11:16, Bastian Blank wrote:
> > I upgraded one of my 32bit chroots on a x86-64 machine runing under Xen
> > lately. All binaries started to segfault. Some extensive checks later
> > show the vdso as the culprit. Later I found <gpe0vg$j67$1@ger.gmane.org>
> > with the same problem. The full story can be found in the Debian bug
> > 544145[1].
> >
> > It happens with Linux 2.6.30 and 2.6.31-rc8 on Xen 3.2 and 3.4.
> >
> > For the tests I set the vdso to compat mode to have it loaded on a fixed
> > location.
> >
> > The following program is a minimal test case for the vdso in compat
> > mode, it can be compiled against dietlibc to minimize other effects.
> 
> Is this an AMD machine?  Does booting with vdso32=0 on the kernel
> command line work around the problem?

AFAIK only AMD support the syscall instruction, so yes it is an AMD
machine. And yes, disabling the only thing that make the glibc call this
instruction works around it.

Bastian

-- 
Conquest is easy. Control is not.
		-- Kirk, "Mirror, Mirror", stardate unknown
