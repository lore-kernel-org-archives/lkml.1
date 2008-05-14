Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYENCnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYENCnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 22:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYENCnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 22:43:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbYENCnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 22:43:41 -0400
Date: Tue, 13 May 2008 19:42:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>
Subject: Re: [patch 6/8] PNP: replace pnp_resource_table with dynamically
 allocated resources
Message-Id: <20080513194241.d11664df.akpm@linux-foundation.org>
In-Reply-To: <20080505224000.013817328@ldl.fc.hp.com>
References: <20080505223630.682082986@ldl.fc.hp.com>
	<20080505224000.013817328@ldl.fc.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 16:36:36 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> PNP used to have a fixed-size pnp_resource_table for tracking the
> resources used by a device.  This table often overflowed, so we've
> had to increase the table size, which wastes memory because most
> devices have very few resources.
> 
> This patch replaces the table with a linked list of resources where
> the entries are allocated on demand.
> 
> This removes messages like these:
> 
>     pnpacpi: exceeded the max number of IO resources
>     00:01: too many I/O port resources
> 
> References:
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=9535
>     http://bugzilla.kernel.org/show_bug.cgi?id=9740
>     http://lkml.org/lkml/2007/11/30/110
> 
> This patch also changes the way PNP uses the IORESOURCE_UNSET,
> IORESOURCE_AUTO, and IORESOURCE_DISABLED flags.

This patch kills my prehistoric dual PIII.

http://userweb.kernel.org/~akpm/p5135912.jpg
http://userweb.kernel.org/~akpm/config-vmm.txt
http://userweb.kernel.org/~akpm/dmesg-vmm.txt
