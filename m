Return-Path: <linux-kernel-owner+w=401wt.eu-S935245AbYEVM2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbYEVM2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbYEVM2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:28:38 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2113 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbYEVM2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:28:37 -0400
Date: Thu, 22 May 2008 14:28:19 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 22 May 2008, Miklos Szeredi wrote:

> > That check didn't used to be there and that the HFS+ check is older than 
> > that might have given you the idea that it at least used to work.
> > So now the only way for a fs to differentiate between lookup and exec is 
> > gone... :-(
> 
> That check was added quite some time ago:
> 
>    commit a343bb7750e6a098909c34f5c5dfddbc4fa40053
>    Author: Trond Myklebust <Trond.Myklebust@netapp.com>
>    Date:   Tue Aug 22 20:06:03 2006 -0400
>    
>        VFS: Fix access("file", X_OK) in the presence of ACLs
> 
> Also it sounds just plain wrong to allow execution without an x bit.
> It could cause nasty surprises at least.  What was the intended
> purpose of that code, and why did nobody notice when it stopped
> working?

As I said to allow lookup on files.

bye, Roman
