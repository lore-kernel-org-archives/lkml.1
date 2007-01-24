Return-Path: <linux-kernel-owner+w=401wt.eu-S965473AbXAXAtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473AbXAXAtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXAXAtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:49:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965473AbXAXAtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:49:23 -0500
Date: Tue, 23 Jan 2007 16:45:41 -0800
From: Andrew Morton <akpm@osdl.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] seq_file conversion: APM on arm
Message-Id: <20070123164541.42faf54e.akpm@osdl.org>
In-Reply-To: <20070115205935.GA5010@martell.zuzino.mipt.ru>
References: <20070115205935.GA5010@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jan 2007 23:59:35 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Compile-tested.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  arch/arm/kernel/apm.c |   28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
> 
> --- a/arch/arm/kernel/apm.c
> +++ b/arch/arm/kernel/apm.c

There is an ongoing desultory effort from Ralf to unify the ARM and MIPS
APM implementations.  Independently converting them both to use seqfile
at this stage might muck that up.   Ralf, talk to me?
