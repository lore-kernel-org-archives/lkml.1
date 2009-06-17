Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZFQU4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZFQU4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZFQU4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:56:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbZFQU4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:56:41 -0400
Date: Wed, 17 Jun 2009 13:56:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <willy@linux.intel.com>
cc: jbarnes@virtuousgeek.org, andrew.patterson@hp.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ia64: Fix resource assignment for root busses
In-Reply-To: <1245270816-11755-5-git-send-email-willy@linux.intel.com>
Message-ID: <alpine.LFD.2.01.0906171356040.16802@localhost.localdomain>
References: <1245270816-11755-1-git-send-email-willy@linux.intel.com> <1245270816-11755-5-git-send-email-willy@linux.intel.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Matthew Wilcox wrote:
>
> ia64 was assigning resources to root busses after allocations had
> been made for child busses.  Calling pcibios_setup_root_windows() from
> pcibios_fixup_bus() solves this problem by assigning the resources to
> the root bus before child busses are scanned.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> Tested-by: Andrew Patterson <andrew.patterson@hp.com>

So I assume this "Tested-by:" means that Andrew confirmed that this 
actually fixes the nesting? I wasn't cc'd on that, so I'm just checking..

		Linus
