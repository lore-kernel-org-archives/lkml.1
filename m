Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYFJN7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYFJN7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYFJN7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:59:41 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34091 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYFJN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:59:40 -0400
Date: Tue, 10 Jun 2008 09:57:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: peter.oberparleiter@de.ibm.com, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org, oberparleiter@googlemail.com
Subject: Re: 2.6.26-rc5-mm1: uml link error
Message-ID: <20080610135729.GA6087@c2.user-mode-linux.org>
References: <E1K5oBn-0006v4-KJ@pomaz-ex.szeredi.hu> <484E5CBB.2040203@de.ibm.com> <E1K61st-0008JT-9e@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K61st-0008JT-9e@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 01:19:27PM +0200, Miklos Szeredi wrote:
> Hmm, uml still doesn't boot with this patch, it dies while calling the
> constructors.  So maybe that SORT contruct is still needed?
> 
> #17 0x08049793 in do_ctors () at init/main.c:706
> #18 0x080499cc in do_basic_setup () at init/main.c:789
> #19 0x08049a43 in kernel_init (unused=0x0) at init/main.c:897

This doesn't look like it's in do_initcalls.  What happens with
"initcall_debug"?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
