Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbYEWQbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbYEWQbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYEWQb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:31:29 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3525 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYEWQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:31:25 -0400
Date: Fri, 23 May 2008 18:30:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <E1JzZWC-0002M8-UP@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805231824370.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org>
 <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
 <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu> <E1JzZWC-0002M8-UP@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 23 May 2008, Miklos Szeredi wrote:

> And so I strongly suggest this patch as well.  Apparently this feature
> is not even used by anybody, otherwise somebody would have noticed
> when Trond's fix broke execute permission checking on regular files...

And I'm very strongly against this.
If you wanted to rip out the resource inode logic, it would be more than 
this.
At worst this code does nothing right now, so why this sudden rush to 
remove this without even an attempt of fixing it?

bye, Roman
