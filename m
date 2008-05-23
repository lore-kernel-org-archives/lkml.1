Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbYEWVyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbYEWVyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbYEWVyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:54:07 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4241 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbYEWVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:54:05 -0400
Date: Fri, 23 May 2008 23:52:20 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <E1JzcZj-0002mJ-28@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805232347500.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org>
 <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
 <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu> <E1JzZWC-0002M8-UP@pomaz-ex.szeredi.hu>
 <Pine.LNX.4.64.0805231824370.18302@localhost.localdomain>
 <E1Jzbai-0002d1-VC@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805232027220.18302@localhost.localdomain>
 <E1JzcZj-0002mJ-28@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 23 May 2008, Miklos Szeredi wrote:

> Semi-concrete: link(2) locks the target's parent and the source.
> Cross-directory rename(2) locks both parents.  If link's target is a
> file which has children, this can result in an ABBA deadlock.  That's
> _before_ the filesystem's ->link() or ->rename() function is called.

I'm afraid you have to be more concrete than this. 
hfsplus_file_inode_operations doesn't have a link or rename operation, so 
if one your source parents above involves a file, it shouldn't get this 
far or you have to describe your scenario in more detail.

bye, Roman
