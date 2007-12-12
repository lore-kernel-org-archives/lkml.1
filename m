Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbXLLIRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbXLLIRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbXLLIQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:16:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754903AbXLLIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:16:55 -0500
Date: Wed, 12 Dec 2007 00:16:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx,
       linux-acpi@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Li Shaohua <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PNP: do not stop/start devices in suspend/resume path
Message-Id: <20071212001610.6506c6d2.akpm@linux-foundation.org>
In-Reply-To: <200712061625.57660.bjorn.helgaas@hp.com>
References: <4745F77C.7040402@gmail.com>
	<47514CE2.3000600@gmail.com>
	<200712051124.18852.bjorn.helgaas@hp.com>
	<200712061625.57660.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 16:25:57 -0700 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Andrew, can you add this before
> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch?
> 
> ...
>
> PNP: do not stop/start devices in suspend/resume path

I did, but I also temporarily dropped
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch.

Is it expected that this patch will fix
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch? 
Should I bring it back?
