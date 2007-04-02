Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbXDBGM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbXDBGM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbXDBGM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:12:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbXDBGMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:12:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable entries
Date: Mon, 2 Apr 2007 08:12:18 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <20070402055652.610711908@goop.org> <20070402055704.278590661@goop.org>
In-Reply-To: <20070402055704.278590661@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020812.18320.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 07:56, Jeremy Fitzhardinge wrote:
> Add a set of accessors to pack, unpack and modify page table entries
> (at all levels).  This allows a paravirt implementation to control the
> contents of pgd/pmd/pte entries.  For example, Xen uses this to
> convert the (pseudo-)physical address into a machine address when
> populating a pagetable entry, and converting back to pphys address
> when an entry is read.

What do the benchmarks say with CONFIG_PARAVIRT on native hardware
compared to !CONFIG_PARAVIRT. e.g. does lmbench suffer? 

-Andi
