Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbZKAJyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbZKAJyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 04:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZKAJyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 04:54:08 -0500
Received: from www84.your-server.de ([213.133.104.84]:57783 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZKAJyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 04:54:07 -0500
Subject: Re: [PATCH] proc: fix ->stack_start in compat mode
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, m.s.tsirkin@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091028115602.GA26295@x200>
References: <20091028115602.GA26295@x200>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 01 Nov 2009 10:54:05 +0100
Message-ID: <1257069245.3975.6.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 28.10.2009, 14:56 +0300 schrieb Alexey Dobriyan:
> Assign tsk->stack_start even when doing compat execve(2).
> 
> As side effect, fix segfault inside boehm-gc library.
> http://bugzilla.kernel.org/show_bug.cgi?id=14478
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  Michael, please, confirm.
> 
>  Stefani, I get "Stack usage: 0 kB", you may want to look at it.
> 

Under which circumstance do you get 0 kb reported? What is your system
(mmu/nommu, 32bit/64bit, architecture and so on).

Stefani


