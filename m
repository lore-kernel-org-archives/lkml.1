Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbZKDSa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbZKDSa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbZKDSaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:30:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757814AbZKDSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:30:23 -0500
Date: Wed, 4 Nov 2009 10:29:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resources: when allocate_resource() fails, leave resource
 untouched
In-Reply-To: <20091104102026.5698a9b4@jbarnes-piketon>
Message-ID: <alpine.LFD.2.01.0911041025350.31845@localhost.localdomain>
References: <20091102174536.12512.56685.stgit@bob.kio> <20091104102026.5698a9b4@jbarnes-piketon>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Nov 2009, Jesse Barnes wrote:
> 
> Seems like a reasonable change to me.  Linus is usually the gatekeeper
> for resource.c.

I'm certainly ok with this one. I wouldn't be surprised if it even allows 
for better code generation, apart from leaving resources untouched when 
allocation fails. So:

	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

It was apparently sent to Andrew, but I can certainly take it. Or you can 
take it into the PCI tree. Or we can leave it in -mm. Anything goes. Just 
tell me.

			Linus
