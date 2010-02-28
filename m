Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032063Ab0B1Uqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:46:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032025Ab0B1Uqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:46:49 -0500
Date: Sun, 28 Feb 2010 12:46:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34
In-Reply-To: <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain>
References: <20100226093957.7b99d09c@jbarnes-piketon> <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Feb 2010, Linus Torvalds wrote:
> 
> I just bisected a Nouveau boot failure to commit 977d17bb17 ("PCI: update 
> bridge resources to get more big ranges in PCI assign unssigned"), and I'm 
> going to revert that today one unless I can get a patch that fixes it for 
> me.

Btw, it's not just bisected, I also verified that a revert on top of the 
current git tree does fix it for me.

			Linus
