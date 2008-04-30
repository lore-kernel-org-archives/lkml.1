Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbYD3ALu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbYD3ALu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 20:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYD3ALl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 20:11:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:31051 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbYD3ALl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 20:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XMJfuFHW7pt7Om1x0Q4hDOtU9En4y57RjPRAw3TqvuzXOibOX95zvOf1LjqeVCEuQloQGj7Kf9/vCBgLFfgfkGf2kLLh1I8YaEzxDuG4SkrZnpssc7MR/FNhViCKtFnyDqWUM0n1xepxGWib1w/QAak2KBA0n7I4YJLkBreZ1oE=
Subject: Re: [2.6 patch] fix arch/frv/mm/unaligned.o build error
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080429235740.GC15987@cs181133002.pp.htv.fi>
References: <20080429235740.GC15987@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 17:11:49 -0700
Message-Id: <1209514311.24729.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 02:57 +0300, Adrian Bunk wrote:
> This patch fixes the following build error caused by
> commit 6510d41954dc6a9c8b1dbca7eaca0f23195ca727
> (kernel: Move arches to use common unaligned access):
> 
> <--  snip  -->
> 
> ...
> make[2]: *** No rule to make target `arch/frv/mm/unaligned.o', needed by `arch/frv/mm/built-in.o'.  Stop.
> make[1]: *** [arch/frv/mm] Error 2
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks Adrian, I must have missed a git add during some of the revisions
this patchset went through.

Reviewed-by: Harvey Harrison <harvey.harrison@gmail.com>

