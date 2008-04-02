Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYDBGDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYDBGDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYDBGDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:03:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbYDBGDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:03:31 -0400
Date: Tue, 1 Apr 2008 23:03:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.25-rc8-mm1
Message-Id: <20080401230322.331c50f4.akpm@linux-foundation.org>
In-Reply-To: <47F31C46.9000503@gmail.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	<47F31C46.9000503@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 09:40:22 +0400 Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Hi Andrew,
> 
> MIPS build fails with the following:
> 
> $ make ARCH=mips CROSS_COMPILE=mips-unknown-linux-gnu-
> ...
> [skipped]
> ...
>   CC      arch/mips/mips-boards/generic/init.o
> In file included from include/asm/cacheflush.h:13,
>                  from arch/mips/mips-boards/generic/init.c:30:
> include/linux/mm.h:411:63: "NR_PAGEFLAGS" is not defined
> include/linux/mm.h:459:62: "NR_PAGEFLAGS" is not defined
> make[1]: *** [arch/mips/mips-boards/generic/init.o] Error 1
> make: *** [arch/mips/mips-boards/generic] Error 2

ahh, yup, known problem, sorry.  We are slowly working on a fix.
