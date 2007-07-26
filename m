Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbXGZFBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbXGZFBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXGZFBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:01:39 -0400
Received: from ozlabs.org ([203.10.76.45]:47218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbXGZFBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:01:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18088.10923.67233.336636@cargo.ozlabs.ibm.com>
Date: Thu, 26 Jul 2007 15:01:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Meelis Roos <mroos@linux.ee>
Cc: linuxppc-dev@ozlabs.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix ppc kernels after build-id addition
In-Reply-To: <Pine.SOC.4.64.0707251301200.21641@math.ut.ee>
References: <Pine.SOC.4.64.0707251301200.21641@math.ut.ee>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos writes:

> This patch fixes arch/ppc kernels, at least for prep subarch, after 
> build-id addition. Without the patch, kernels were 3 times the size and 
> bootloader refused to load them. Now they are back to normal again.

I just built an ARCH=ppc kernel for the prep subarch and the vmlinux
size was normal.  Can you identify exactly why the kernels got so much
bigger, i.e. what is taking up all the space?

Paul.
