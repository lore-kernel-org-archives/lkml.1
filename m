Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYJUQsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYJUQsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYJUQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:48:11 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60720 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbYJUQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:48:09 -0400
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Pavel Machek <pavel@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081021095002.GA5880@atrey.karlin.mff.cuni.cz>
References: <1224552902.2640.88.camel@alok-dev1>
	 <20081021095002.GA5880@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 09:48:08 -0700
Message-Id: <1224607688.6161.25.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 02:50 -0700, Pavel Machek wrote:
> > Hi,
> >
> > This patch set makes some changes to the TSC code, so that it is always
> > used as the default clocksource when running under VMware.
> > The first 2 patches do the ground work of adding code to detect if we
> > are running under VMware.
> > The third patch adds a tsc_reliable flag which tells us that TSC is
> > reliable on this system, so that we can skip some tests which can
> > potentially mark TSC as unstable. Details under individual patch
> > headers.
> 
> How do you _know_ TSC is stable under VMWare? 

Since we implement it that way :)
The hypervisor takes care of providing a constant rate TSC to the guest
on such systems which have variable frequency.

Thanks,
Alok

> AFAICT, accesses to TSC
> are not virtualized and system VMWare runs on may still use frequency
> scaling, no?
>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

