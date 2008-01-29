Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYA2H5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYA2H5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 02:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYA2H5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 02:57:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56390 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYA2H47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 02:56:59 -0500
Date: Tue, 29 Jan 2008 09:31:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Joachim Deguara <joachim.deguara@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Dean Roe <roe@cray.com>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c II
Message-ID: <20080129083112.GA1466@one.firstfloor.org>
References: <200801281211.28214.joachim.deguara@amd.com> <p73y7a970nd.fsf@bingen.suse.de> <200801282012.47190.yinghai.lu@sun.com> <20080129045659.GA31847@one.firstfloor.org> <20080129080927.GA1414@one.firstfloor.org> <86802c440801282339q77a585f5h82df44295ddfb6fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440801282339q77a585f5h82df44295ddfb6fd@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 11:39:30PM -0800, Yinghai Lu wrote:
> On Jan 29, 2008 12:09 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > > SRAT is essentially just a two dimensional table with node distances.
> >
> > Sorry, that was actually SLIT. SRAT is not two dimensional, but also
> > relatively simple. SLIT you don't really need to implement.
> >
> 
> need to add some CONFIG option to parse SRAT, MADT etc only. but don't
> pull DSDT related...

I don't think it needs a CONFIG. The code should handle this case 
by itself in any case. I'm not entirely sure it does currently, but if it 
doesn't it will likely not be very difficult to fix.

Or are you worried about code size? ACPI is around ~270k on x86-64, 
which while certainly not small should not be a problem on x86 NUMA
systems.

-Andi

