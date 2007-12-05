Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXLEQhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXLEQhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXLEQha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:37:30 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:63517 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXLEQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:37:29 -0500
Date: Wed, 5 Dec 2007 17:37:24 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] x86_64: some whitespace cleanups in paging code
Message-ID: <20071205163724.GA1024@osiris.boeblingen.de.ibm.com>
References: <20071205123033.GA15394@elte.hu> <1196865612128-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196865612128-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 03:40:12PM +0100, Joerg Roedel wrote:
> This patch does some whitespace cleanups in the paging code to fix some
> checkpatch.pl warnings of my formerly merged cleanup patches.
>...
> -			set_pmd(pmd + i,__pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
> +			set_pmd(pmd+i, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));

Did checkpatch enforce you to remove the spaces around '+'? I thought
there was/is a common consensus that having spaces around operators is a good
thing to have. IMHO it's much more readable...
But anyway, it's not that I want to start a new thread about coding style :)
