Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbXIINqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbXIINqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 09:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbXIINqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 09:46:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37126 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbXIINqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 09:46:05 -0400
Date: Sun, 9 Sep 2007 15:46:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "James C. Georgas" <jgeorgas@georgas.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KCONFIG: fix pseudo dependency between K8_NUMA and X86_64_ACPI_NUMA config options
Message-ID: <20070909134602.GA25798@one.firstfloor.org>
References: <1189291899.13467.20.camel@Tachyon.home> <20070908180904.656f3d03.randy.dunlap@oracle.com> <1189300961.13467.47.camel@Tachyon.home> <p734pi4rytz.fsf@bingen.suse.de> <1189343945.7365.9.camel@Tachyon.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189343945.7365.9.camel@Tachyon.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 09:19:05AM -0400, James C. Georgas wrote:
> On Sun, 2007-09-09 at 11:07 +0200, Andi Kleen wrote:
> > "James C. Georgas" <jgeorgas@georgas.ca> writes:
> > > 
> > > It's 2.6.22.6. I'm thinking a fix would be to add "select PM" to
> > > X86_64_ACPI_NUMA.
> > > 
> > > I'm also thinking that maybe K8_NUMA should be changed from "depends on
> > > PCI" to "select PCI", like X86_64_ACPI_NUMA is. That would fix the
> > > pseudo dependency they have between them (i.e. selecting
> > > X86_64_ACPI_NUMA causes PCI to be selected, which then makes K8_NUMA
> > > visible, because its PCI dependency is now satisfied).
> > 
> > Sounds reasonable. Can you please submit a tested patch with proper
> > description and Signed-off-by lines?
> > 
> > -Andi
> 
> How's this?

Thanks. How about a fix for the other problem (ACPI_NUMA- PM) too?

-Andi
