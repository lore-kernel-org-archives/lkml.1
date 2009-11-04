Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZKDSvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZKDSvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZKDSvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:51:10 -0500
Received: from outbound-mail-136.bluehost.com ([67.222.39.26]:48071 "HELO
	outbound-mail-136.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750848AbZKDSvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:51:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pOvdt9NbP4Fdz/FMwCF+iFXzuPnb0A9RKJaNdw12oZliN9NNAHjMbydXyoZJ3MB32YGjMRXGlN8Z7DgsBzifpc3ovUqRjl36RYL63iZZ5qLtw98vv7Scn+zO8M95H5jK;
Date: Wed, 4 Nov 2009 10:51:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resources: when allocate_resource() fails, leave
 resource untouched
Message-ID: <20091104105112.4cf5233e@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.01.0911041025350.31845@localhost.localdomain>
References: <20091102174536.12512.56685.stgit@bob.kio>
	<20091104102026.5698a9b4@jbarnes-piketon>
	<alpine.LFD.2.01.0911041025350.31845@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 10:29:54 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 4 Nov 2009, Jesse Barnes wrote:
> > 
> > Seems like a reasonable change to me.  Linus is usually the
> > gatekeeper for resource.c.
> 
> I'm certainly ok with this one. I wouldn't be surprised if it even
> allows for better code generation, apart from leaving resources
> untouched when allocation fails. So:
> 
> 	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> It was apparently sent to Andrew, but I can certainly take it. Or you
> can take it into the PCI tree. Or we can leave it in -mm. Anything
> goes. Just tell me.

Ok, I'll pick it up.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
