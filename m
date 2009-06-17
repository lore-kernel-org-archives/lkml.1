Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbZFQUNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbZFQUNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbZFQUNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:13:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbZFQUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:13:14 -0400
Date: Wed, 17 Jun 2009 13:12:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: Matthew Wilcox <matthew@wil.cx>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <1245269316.8234.270.camel@bluto.andrew>
Message-ID: <alpine.LFD.2.01.0906171309500.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>  <4A38B3B4.1020304@jp.fujitsu.com> <20090617134311.GR19977@parisc-linux.org>  <alpine.LFD.2.01.0906170922380.16802@localhost.localdomain>  <1245260533.8234.241.camel@bluto.andrew> 
 <alpine.LFD.2.01.0906171047050.16802@localhost.localdomain> <1245269316.8234.270.camel@bluto.andrew>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Andrew Patterson wrote:
> > 
> > This is why I'd really like to see the output of my test-patch. It would 
> > show exactly _where_ that resource is inserted, and the whole call-chain.
> > 
> > I'm appending a version that only does it for resources that have names 
> > starting with "PCI Bus", so it should be less noisy. But again, it's 
> > totally untested.
> > 
> 
> Here you go (I can provide the full boot log if needed). Note, there is
> nothing for c3 here:

Ok, so that means it got inserted into the resource tree some other way 
entirely. Or maybe the name got changed after-the-fact. Both of which 
imply that something is really really wrong.

The ones your trace _does_ show are the ones that got inserted correctly 
and aren't buggy. Can anybody see how that buggy resource got inserted?

		Linus
