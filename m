Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYFVJsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYFVJsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYFVJs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:48:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50874 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYFVJs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:48:26 -0400
Date: Sun, 22 Jun 2008 10:48:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: Re: alpha build failure
Message-ID: <20080622094817.GS28946@ZenIV.linux.org.uk>
References: <20080622085313.GC27069@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622085313.GC27069@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 11:53:13AM +0300, Adrian Bunk wrote:
> Commit 9267b4b3880d00dc2dab90f1d817c856939114f7
> (alpha: fix module load failures on smp (bug #10926))
> causes the following build failure with the alpha defconfig:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/alpha/mm/init.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/alpha/mm/init.c:34: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'typeof'
> make[2]: *** [arch/alpha/mm/init.o] Error 1
> 
> <--  snip  -->

Missing PER_CPU_ATTRIBUTES in asm-alpha/percpu.h if !SMP...
