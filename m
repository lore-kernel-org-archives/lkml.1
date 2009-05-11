Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZEKQDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZEKQDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZEKQDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:03:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbZEKQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:03:38 -0400
Date: Mon, 11 May 2009 12:03:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, adobriyan@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86, 64-bit: ifdef out struct thread_struct::ip
Message-ID: <20090511160324.GA7923@infradead.org>
References: <20090503233015.GJ16631@x200.localdomain> <tip-0c23590f00f85467b318ad0c20c36796a5bd4c60@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-0c23590f00f85467b318ad0c20c36796a5bd4c60@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 03:09:40PM +0000, tip-bot for Alexey Dobriyan wrote:
> +#ifdef CONFIG_X86_32
>  	unsigned long		ip;
> +#endif
>  #ifdef CONFIG_X86_64
>  	unsigned long		fs;
>  #endif

What happened to the good old concept of #if #else #endif?

