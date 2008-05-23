Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYEWPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYEWPNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYEWPNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:13:39 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2556 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYEWPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:13:38 -0400
Date: Fri, 23 May 2008 17:11:55 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805231709040.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 22 May 2008, Miklos Szeredi wrote:

> > As I said to allow lookup on files.
> 
> That requires a quite bit more support from the VFS than just allowing
> lookup to work on regular files without x bits.  You'll have big
> trouble with hard links for example: the VFS doesn't like non-leaf
> dentries to be aliased.
> 
> Besides hfsplus_permission() did not differentiate between execve on
> the file and lookup on that file, allowing both.  Which is obviously
> wrong.

I'm not saying it's perfect. I wished there was a MAY_LOOKUP to clearly 
differentiate both cases.
For now I'd rather keep it as it is and I'll look into it when I find the 
time.

bye, Roman
