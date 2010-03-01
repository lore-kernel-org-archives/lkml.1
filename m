Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0CASoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:44:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49313 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0CASoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:44:30 -0500
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       trenn@suse.de
Subject: Re: [LKML] Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org>
	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>
	<4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>
	<20100301164602.GG7881@phenom.dumpdata.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Mar 2010 10:44:23 -0800
In-Reply-To: <20100301164602.GG7881@phenom.dumpdata.com> (Konrad Rzeszutek Wilk's message of "Mon\, 1 Mar 2010 11\:46\:02 -0500")
Message-ID: <m1y6ib6fw8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

>> 
>> > so far this patch only affect (fix ) x3950.
>
> .. snip ..
>> > other solution will ask IBM to fix their bios, so we can get
>
> It isn't just IBM. Asus P2B-D (PIIX4) and SuperMicro X8DAL (possibly)
> seem to have the same issue.
>
> (http://lists.xensource.com/archives/html/xen-devel/2010-02/msg00715.html)
> and
> (http://lists.xensource.com/archives/html/xen-devel/2010-02/msg01239.html)

I can't find the reference to those boards in the email you quoted.  Xen
does strange and very different things with it's irqs so it is unlikely to
be the same issue.

Eric
