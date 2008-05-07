Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYEGEB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYEGEB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYEGEBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:01:30 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44645 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYEGEB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:01:29 -0400
Date: Wed, 7 May 2008 00:00:20 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: [uml-devel] [PATCH] fix UML on x86-64
Message-ID: <20080507040020.GA15972@c2.user-mode-linux.org>
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805062304.m46N4h6d007206@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 07:04:43PM -0400, Ulrich Drepper wrote:
> This patch breaks UML for me on x86-64 running Fedora 8 (gcc 4.1.2):

Two odd things -
    I'm using what appears to be the same environment - F8, gcc 4.1.2
	gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)
and I've seen nothing like this

    --showconfig doesn't work.  This is implemented in
arch/um/kernel/config.c.in (which becomes config.c after some
preprocessing), and as far as I can tell, it's just not in the
binary.  So, I'm wondering whether there's something odd with __used.

	     	 	   Jeff

-- 
Work email - jdike at linux dot intel dot com
