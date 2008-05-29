Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbYE2TzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbYE2TzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758322AbYE2TxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:53:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50973 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355AbYE2TxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:53:08 -0400
Date: Thu, 29 May 2008 22:50:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Werror: Hide warnings on static module device
	tables
Message-ID: <20080529195009.GC32180@cs181133002.pp.htv.fi>
References: <20080529192439.GB32180@cs181133002.pp.htv.fi> <20080529181726.5396.79336.stgit@warthog.procyon.org.uk> <20080529181741.5396.66279.stgit@warthog.procyon.org.uk> <3009.1212090107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3009.1212090107@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 08:41:47PM +0100, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Isn't the warning often a reminder that a driver should be updated to 
> > use pci_register_driver() etc. ?
> 
> If it is, it's not mentioned in Documentation/ or at the definition of
> MODULE_DEVICE_TABLE.

It might not be intentionally, but the warning goes away when you stuff 
the table into a struct pci_driver.

> Also, does that apply to the isapnp driver?

There's struct pnp_driver together with pnp_register_driver() etc.

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

