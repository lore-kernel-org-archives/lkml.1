Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab0CARMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:12:24 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:18331 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0CARMW (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 1 Mar 2010 12:12:22 -0500
Date: Mon, 1 Mar 2010 11:46:02 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       trenn@suse.de
Subject: Re: [LKML] Re: [tip:x86/apic] x86: Fix out of order gsi -- add
	remap_ioapic_gsi_to_irq()
Message-ID: <20100301164602.GG7881@phenom.dumpdata.com>
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org> <4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zl2ue585.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B8BF4A1.01D5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > so far this patch only affect (fix ) x3950.

.. snip ..
> > other solution will ask IBM to fix their bios, so we can get

It isn't just IBM. Asus P2B-D (PIIX4) and SuperMicro X8DAL (possibly)
seem to have the same issue.

(http://lists.xensource.com/archives/html/xen-devel/2010-02/msg00715.html)
and
(http://lists.xensource.com/archives/html/xen-devel/2010-02/msg01239.html)
