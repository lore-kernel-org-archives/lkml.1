Return-Path: <linux-kernel-owner+w=401wt.eu-S1763794AbZFQOpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763794AbZFQOpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZFQOpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:45:18 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:51709 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbZFQOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:45:17 -0400
Date: Wed, 17 Jun 2009 18:45:14 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
	resources trees
Message-ID: <20090617144513.GA17720@jurassic.park.msu.ru>
References: <20090616220419.14021.84524.stgit@bob.kio> <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain> <1245192703.8234.226.camel@bluto.andrew> <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain> <alpine.LFD.2.01.0906161623240.16802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906161623240.16802@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 04:32:18PM -0700, Linus Torvalds wrote:
> > So your patch may fix a bug, but I'm pretty sure I've seen a patch from 
> > Ivan that should _also_ fix it, and that I would expect to do it not by 
> > just tweaking a fundamentally ambiguous case.
> 
> Hmm. For the life of me, I can't seem to find this patch. Maybe it wasn't 
> Ivan who wrote it after all. Or maybe my google-fu is weak. Or maybe I'm 
> just delusional, and the patch never existed.

No, it wasn't me.

Anyway, pci_claim_resource() fix suggested by Matthew seems to be
correct, if the problematic system was indeed ia64 and not x86.

Ivan.
