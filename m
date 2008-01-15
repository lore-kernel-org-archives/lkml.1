Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYAOUgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYAOUgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYAOUgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:36:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbYAOUgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:36:40 -0500
Date: Tue, 15 Jan 2008 12:35:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Yuusei KUWANA <kuwana@nyanyan.to>
Subject: Re: [PATCH] CRIS v10: vmlinux.lds.S Fix kernel oops on boot and use
 common defines
Message-Id: <20080115123515.126b9cad.akpm@linux-foundation.org>
In-Reply-To: <20080115133624.GD3912@axis.com>
References: <20080115133624.GD3912@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 14:36:24 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> - Move alignment to page size of init data outside ifdef for BLK_DEV_INITRD.
>   The reservation up to page size of memory after init data was previously
>   not done if BLK_DEV_INITRD was undefined.
>   This caused a kernel oops when init memory pages were freed after startup,
>   data placed in the same page as the last init memory would also be freed
>   and reused, with disastrous results.

So this is a 2.6.24 thing?

> - Use macros for initcalls and .text sections.
> 
> - Replace hardcoded page size constant with PAGE_SIZE define.
> 
> - Change include/asm-cris/page.h to use the _AC macro to instead
>   of testing __ASSEMBLY__.

Even though those are not.
