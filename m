Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbXKMV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbXKMV3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbXKMV3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:29:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbXKMV3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:29:03 -0500
Date: Tue, 13 Nov 2007 22:29:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: William Cohen <wcohen@redhat.com>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       Andi Kleen <andi@firstfloor.org>, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113212902.GA17593@one.firstfloor.org>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113211345.GB5747@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:13:45PM -0800, Stephane Eranian wrote:
> Oprofile does not setup the PMU interrupt. It builds on top of the NMI watchdog
> setup.

Oprofile works without the NMI watchdog too, but it just happens to be another
NMI user.

> It uses the register_die() mechanism, 

Not correct.

> if I recall. The low level APIC
> and gate is setup elsewhere. Perfmon does not use NMI, unless forced to because
> of the NMI watchdog. 

It could handle it in the same way as oprofile if it wanted. But given
NMIs make everything more complicated and it might not be worth it.

-Andi
