Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZCYT4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZCYT4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZCYT4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:56:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZCYT4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:56:42 -0400
Subject: Re: [PATCH] module: Kill warning: label 'free_init' defined but
 not used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, dmitri.vorobiev@movial.com
In-Reply-To: <Pine.LNX.4.64.0903252041190.14101@anakin>
References: <Pine.LNX.4.64.0903252041190.14101@anakin>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 01:24:45 +0530
Message-Id: <1238010885.2500.65.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 20:43 +0100, Geert Uytterhoeven wrote:
> On m68k (which doesn't do SMP), I get:
> 
> | kernel/module.c:2291: warning: label 'free_init' defined but not used
> 
> which was introduced by commit 6e2b75740bed35df98b8113300579e13ed2ce848
> ("module: fix refptr allocation and release order").
> Move the label inside the #ifdef, as the goto is protected by the same #ifdef.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

AFAIK, it is already fixed in -tip:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=67f5ca081c6ace125e8ccc76b8a7d99b091abaa7

--
JSR

