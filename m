Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZH3Pmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZH3Pmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 11:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZH3Pmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 11:42:32 -0400
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:36754 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752163AbZH3Pmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 11:42:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LRJaBQqiU0LnNDo5OVyTbN2noZ7iPItdv3nm6iegLdICG5OL2tPZ2EdUIhdJQumSRvTY6uzPZtqA+GX96xIx950Xe+tWmGB2/PeZ3Q7+BNwMRM6dim1673f9ExkH0bOg;
Date: Sun, 30 Aug 2009 08:42:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: Re: [RFC patch 4/4] x86: Add pci subarch init to x86_init
Message-ID: <20090830084216.7afd48f6@jbarnes-g45>
In-Reply-To: <20090830122528.727735101@linutronix.de>
References: <20090830122225.608718729@linutronix.de>
	<20090830122528.727735101@linutronix.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Aug 2009 13:05:42 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Replace the #ifdef'ed olpc specific init function by a conditional
> x86_init function. This hook is also helpful for the upcoming
> Moorestown support.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/olpc.h     |   20 ++------------------
>  arch/x86/include/asm/pci_x86.h  |    1 -
>  arch/x86/include/asm/x86_init.h |    4 +++-
>  arch/x86/kernel/olpc.c          |    8 +++++---
>  arch/x86/pci/init.c             |    7 +++----
>  arch/x86/pci/olpc.c             |    3 ---
>  6 files changed, 13 insertions(+), 30 deletions(-)

This is definitely nicer than what we have today...  There's one other
PCI patch for MRST in my pci tree:
http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=shortlog;h=mrst-support
it might also need updating in light of these changes.

-- 
Jesse Barnes, Intel Open Source Technology Center
