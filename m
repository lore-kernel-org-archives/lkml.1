Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZA1Bms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZA1Bms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 20:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZA1Bmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 20:42:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbZA1Bmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 20:42:38 -0500
Date: Tue, 27 Jan 2009 17:41:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [PATCH -mmotm] mm: unify some pmd_*() functions
Message-Id: <20090127174158.519e5abd.akpm@linux-foundation.org>
In-Reply-To: <1232919337-21434-1-git-send-email-righi.andrea@gmail.com>
References: <1232919337-21434-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 22:35:37 +0100
Andrea Righi <righi.andrea@gmail.com> wrote:

> diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
> index a7cdc48..b132d69 100644
> --- a/include/asm-generic/pgtable-nopmd.h
> +++ b/include/asm-generic/pgtable-nopmd.h
> @@ -4,6 +4,7 @@
>  #ifndef __ASSEMBLY__
>  
>  #include <asm-generic/pgtable-nopud.h>
> +#include <asm/bug.h>
>  
>  struct mm_struct;
>  

Why not include the preferred <linux/bug.h>?

> BTW, I only tested this on x86 and x86_64. This needs more testing because it
> touches also a lot of other architectures.

Hopefully Geert, Roman, David and Hirokazu Takata will have time to
help out here.
