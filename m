Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYEWPSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYEWPSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYEWPSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:18:39 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1668 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYEWPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:18:38 -0400
Date: Fri, 23 May 2008 17:18:26 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <20080523092114.GD27119@infradead.org>
Message-ID: <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 23 May 2008, Christoph Hellwig wrote:

> Yes.  Roman, if you care about details about the files as directories
> look in the reiser4 threads as it did something quite similar.

I was afraid this would come up. :)
I only need something much simpler, I don't need to create/move/unlink 
anything, I only need a lookup+open.
The reiser4 stuff goes a little too far, so very much would like to avoid 
wading through this mess...

bye, Roman
