Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZCYWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZCYWxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZCYWxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:53:06 -0400
Received: from ozlabs.org ([203.10.76.45]:54218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZCYWxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:53:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] module: Kill warning: label 'free_init' defined but not used
Date: Thu, 26 Mar 2009 09:22:57 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0903252041190.14101@anakin>
In-Reply-To: <Pine.LNX.4.64.0903252041190.14101@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903260922.57393.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009 06:13:06 Geert Uytterhoeven wrote:
> On m68k (which doesn't do SMP), I get:
> 
> | kernel/module.c:2291: warning: label 'free_init' defined but not used
> 
> which was introduced by commit 6e2b75740bed35df98b8113300579e13ed2ce848
> ("module: fix refptr allocation and release order").
> Move the label inside the #ifdef, as the goto is protected by the same #ifdef.

Thanks, already in my tree.  I'll get off my ass and push to Linus in next
couple of days.

Thanks!
Rusty.
