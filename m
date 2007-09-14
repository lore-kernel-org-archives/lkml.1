Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbXINRUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbXINRUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXINRUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:20:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32891 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXINRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:20:45 -0400
Date: Fri, 14 Sep 2007 12:20:37 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@osdl.org>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: rtc-ds1742.c should use resource_size_t for base address
Message-ID: <20070914122037.65a08f48@weaponx.rchland.ibm.com>
In-Reply-To: <20070914055427.GM481@localhost.localdomain>
References: <20070914055427.GM481@localhost.localdomain>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; powerpc-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 15:54:27 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> Currently the rtc driver, rtc-ds1742.c uses an unsigned long to store
> the base mmio address of the NVRAM/RTC.  This breaks on systems like
> PowerPC 440, which is a 32-bit core with 36-bit physical addresses: IO
> on the system, including the RTC, is typically above the 4GB point,
> and cannot fit into an unsigned long.
> 
> This patch fixes the problem by replacing the unsigned long with a
> resource_size_t.  Tested on Ebony (PPC440) (with additional patches to
> instantiate the ds1742 platform device appropriately).

Where would those additional patches be? :)

josh
