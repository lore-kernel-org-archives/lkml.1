Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZEZA5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZEZA5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZEZA5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:57:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZEZA5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:57:02 -0400
Message-ID: <4A1B3E41.5030003@zytor.com>
Date: Mon, 25 May 2009 17:56:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the x86 tree with Linus' tree
References: <20090526105249.986c4f3c.sfr@canb.auug.org.au>
In-Reply-To: <20090526105249.986c4f3c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the x86 tree got a conflict in
> arch/x86/boot/memory.c between commit
> bca23dba760d6705c013f89113c46570378fb626 ("x86, setup: revert ACPI 3 E820
> extended attributes support") from Linus' tree and commit
> df7699c56421c0476704f24a43409ac8c505f3d2 ("x86, setup: "glove box" BIOS
> interrupts in the core boot code") from the x86 tree.
> 
> The former removed the code that the latter modified, so I used the
> former (as is done in -tip).

tip:x86/setup should contain a proper merge between the two.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

