Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZENTP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZENTP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZENTPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:15:18 -0400
Received: from outbound-mail-304.bluehost.com ([67.222.53.250]:46308 "HELO
	outbound-mail-304.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751766AbZENTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:15:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Q2OCPd0b5y6/bdxfuxugHEuYVx00qu9cJ4yZ7JHtZ7qqFQk1LMXKyYM6Vgo79DdhQpDzrVircSFSlV4yFR8hfHM8sFnDKRe0uzZB6CO5X7jFCqxFdZoVb63SD8BeUw7g;
Date: Thu, 14 May 2009 12:15:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
Message-ID: <20090514121513.198ada4e@jbarnes-g45>
In-Reply-To: <4A0C66DB.9020707@goop.org>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>
	<1242164891-3859-7-git-send-email-jeremy@goop.org>
	<20090513095535.140134e1@jbarnes-g45>
	<4A0AFE84.2040805@goop.org>
	<20090513102316.5ef3ce4e@jbarnes-g45>
	<4A0C66DB.9020707@goop.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 11:45:47 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jesse Barnes wrote:
> > Anyway it's not a big deal, this code is already ugly (a 0 define
> > for all arches?  why?) so you shouldn't have to spend too much time
> > cleaning it up.
> >   
> 
> OK, how's this as a delta (I can fold it into the previous patch if 
> you're OK with it):
> 
> Subject: [PATCH] pci: add HAVE_ARCH_PCIBIOS_SCAN_ALL_FNS
> 
> Jesse objected to the "#undef pcibios_scan_all_fns"'s ugliness,
> so replace it with the more common HAVE_ARCH_ idiom.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

That's slightly better.  It looks like we should just get rid of
pcibios_scan_all_fns altogether, but this is fine for now.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
