Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZCFV0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZCFV0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZCFV0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:26:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:55064 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZCFV0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:26:37 -0500
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090306114149.GA5371@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
	 <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch>
	 <1236318629.7260.120.camel@pasglop> <20090306090906.GA5183@soziologie.ch>
	 <1236333440.7260.136.camel@pasglop>  <20090306114149.GA5371@soziologie.ch>
Content-Type: text/plain
Date: Sat, 07 Mar 2009 08:26:07 +1100
Message-Id: <1236374767.7260.152.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 12:41 +0100, Gaudenz Steinlin wrote:
> 
> Adding this fixes the bug. Apparently the PCI core does not fully
> restore the state. Before your suggestions I also tried to find out
> which part of your commit breaks resume and I found out that if I
> reinsert the parts to save and restore the pci configuration the bug
> is
> fixed. It seems that somehow the PCI coniguration is not fully
> restored [1].  

Ok, well, I though it would be due to some upstream changes but it's
possible that I either mis-read those changes or they got themselves
changed in some subtle way after I did that commit :-)

I still find it fascinating that it doesn't break for me here since it
is effectively the same machine model !

I'll do a patch fixing that but it will have to wait for monday.

Cheers,
Ben.

