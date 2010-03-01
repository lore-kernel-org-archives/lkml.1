Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab0CATBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:01:09 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:41747 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0CATBH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 1 Mar 2010 14:01:07 -0500
Date: Mon, 1 Mar 2010 13:33:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       trenn@suse.de
Subject: Re: [LKML] Re: [LKML] Re: [tip:x86/apic] x86: Fix out of order gsi
	-- add remap_ioapic_gsi_to_irq()
Message-ID: <20100301183327.GB31926@phenom.dumpdata.com>
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org> <4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org> <20100301164602.GG7881@phenom.dumpdata.com> <m1y6ib6fw8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6ib6fw8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B8C0E0E.020A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 10:44:23AM -0800, Eric W. Biederman wrote:
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
> 
> >> 
> >> > so far this patch only affect (fix ) x3950.
> >
> > .. snip ..
> >> > other solution will ask IBM to fix their bios, so we can get
> >
> > It isn't just IBM. Asus P2B-D (PIIX4) and SuperMicro X8DAL (possibly)
> > seem to have the same issue.
> >
> > (http://lists.xensource.com/archives/html/xen-devel/2010-02/msg00715.html)
> > and
> > (http://lists.xensource.com/archives/html/xen-devel/2010-02/msg01239.html)
> 
> I can't find the reference to those boards in the email you quoted.  Xen

Might have to hit the past button a couple of times. Anyway, here is the
first description of the problem:
http://lists.xensource.com/archives/html/xen-devel/2010-01/msg01049.html

and the board name.

> does strange and very different things with it's irqs so it is unlikely to
> be the same issue.

I think I am confusing the patches. Adding in this patch:

[PATCH 01/35] x86: fix sci on ioapic 1 which was posted by Yinghai Lu on
Feb 9th fixed the issue with the ASUS board.

and the discussion here is for a different patch, so I think I am
raising unnecessary noise here - sorry about that.
