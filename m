Return-Path: <linux-kernel-owner+w=401wt.eu-S1764249AbXFEKHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764249AbXFEKHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763468AbXFEKHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:07:07 -0400
Received: from ns.suse.de ([195.135.220.2]:43551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762807AbXFEKHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:07:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64: change dm_ioremap to ioremap
Date: Tue, 5 Jun 2007 12:06:51 +0200
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <86802c440706042321k4d83a33dpa0a09deb5fbd5a3a@mail.gmail.com>
In-Reply-To: <86802c440706042321k4d83a33dpa0a09deb5fbd5a3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051206.52012.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007 08:21:23 Yinghai Lu wrote:
> [PATCH] x86_64: change dmi_ioremap to ioremap
> 
> dmi_scan_machine==>dmi_present==>dmi_table==>dmi_ioremap uses
> early_ioremap in mm/init.c
> dmi_scan_machine is called after init_memory_mappings, and could use
> ioremap instead.
> also remove extra extern declaring about dmi_ioremap

init_memory_mapping is not enough; it also needs a working 
page allocator. But at this point there is only bootmem.
I don't think the patch is correct.

-Andi
