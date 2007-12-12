Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbXLLQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbXLLQ3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXLLQ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:29:12 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:23606 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbXLLQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:29:11 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PNP: do not stop/start devices in suspend/resume path
Date: Wed, 12 Dec 2007 09:29:06 -0700
User-Agent: KMail/1.9.6
Cc: Jiri Slaby <jirislaby@gmail.com>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx,
       linux-acpi@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Li Shaohua <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <4745F77C.7040402@gmail.com> <200712061625.57660.bjorn.helgaas@hp.com> <20071212001610.6506c6d2.akpm@linux-foundation.org>
In-Reply-To: <20071212001610.6506c6d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712120929.07134.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 01:16:10 am Andrew Morton wrote:
> On Thu, 6 Dec 2007 16:25:57 -0700 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > Andrew, can you add this before
> > pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch?
> > 
> > ...
> >
> > PNP: do not stop/start devices in suspend/resume path
> 
> I did, but I also temporarily dropped
> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch.

Thanks.

> Is it expected that this patch will fix
> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch? 
> Should I bring it back?

No, not yet.  The "do not stop/start" patch should fix the kernel/resource.c
warning, but I don't understand the "acpi reboots machine" (critical temp
reached) problem yet.

Bjorn
