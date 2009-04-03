Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbZDCHd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbZDCHd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZDCHdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:33:50 -0400
Received: from aun.it.uu.se ([130.238.12.36]:33875 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZDCHdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:33:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18901.48028.862826.66492@pilspetsen.it.uu.se>
Date: Fri, 3 Apr 2009 09:32:44 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Stefani Seibold <stefani@seibold.net>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Engel <joern@logfs.org>
Subject: Re: Detailed Stack Information Patch [2/3]
In-Reply-To: <1238707547.3882.24.camel@matrix>
References: <1238511507.364.62.camel@matrix>
	<20090401193639.GB12316@elte.hu>
	<1238707547.3882.24.camel@matrix>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold writes:
 > I think a user space daemon will be the a good way if the /proc/*/maps
 > or /proc/*/stack will provide the following information:
 > 
 > - start address of the stack
 > - current address of the stack pointer
 > - highest used address in the stack

You're assuming
1. a thread has exactly one stack
2. the stack is a single unbroken area
3. the kernel knows the location of this area

None of these assumptions are necessarily valid, esp. in
the presence of virtualizers, managed runtimes, or mixed
interpreted/JIT language implementations.
