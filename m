Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbXJRMXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbXJRMXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbXJRMX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:23:27 -0400
Received: from ozlabs.org ([203.10.76.45]:50703 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbXJRMX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:23:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18199.20538.594159.877930@cargo.ozlabs.ibm.com>
Date: Thu, 18 Oct 2007 22:23:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 - powerpc - Build fails at arch/powerpc/boot/inflate.o
In-Reply-To: <47174C49.5050308@linux.vnet.ibm.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<47174C49.5050308@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal writes:

> The kernel build fails on the power box
> 
>   INSTALL vdso64.so
> 
>   INSTALL vdso32.so
> 
>   BOOTCC  arch/powerpc/boot/inflate.o
> 
> arch/powerpc/boot/inflate.c:920:19: error: errno.h: No such file or directory

This problem is fixed by d4faaecbcc6d9ea4f7c05f6de6af98e2336a4afb in
Linus' tree.

Paul.
