Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbXIIJIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbXIIJIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 05:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbXIIJHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 05:07:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbXIIJHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 05:07:54 -0400
To: "James C. Georgas" <jgeorgas@georgas.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: broken ACPI NUMA config option
References: <1189291899.13467.20.camel@Tachyon.home>
	<20070908180904.656f3d03.randy.dunlap@oracle.com>
	<1189300961.13467.47.camel@Tachyon.home>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Sep 2007 11:07:52 +0200
In-Reply-To: <1189300961.13467.47.camel@Tachyon.home>
Message-ID: <p734pi4rytz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"James C. Georgas" <jgeorgas@georgas.ca> writes:
> 
> It's 2.6.22.6. I'm thinking a fix would be to add "select PM" to
> X86_64_ACPI_NUMA.
> 
> I'm also thinking that maybe K8_NUMA should be changed from "depends on
> PCI" to "select PCI", like X86_64_ACPI_NUMA is. That would fix the
> pseudo dependency they have between them (i.e. selecting
> X86_64_ACPI_NUMA causes PCI to be selected, which then makes K8_NUMA
> visible, because its PCI dependency is now satisfied).

Sounds reasonable. Can you please submit a tested patch with proper
description and Signed-off-by lines?

-Andi
