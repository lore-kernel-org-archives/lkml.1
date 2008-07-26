Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYGZQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYGZQ7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYGZQ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:59:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:52632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYGZQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:59:24 -0400
Date: Sat, 26 Jul 2008 09:59:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/byteorder.h, CONFIG_X86_BSWAP leaks to userland
Message-ID: <20080726095901.4a06daf9@infradead.org>
In-Reply-To: <488B555F.4090709@zytor.com>
References: <20080726013931.bcc4682d.akpm@linux-foundation.org>
	<1217090446.5971.57.camel@brick>
	<488B555F.4090709@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 12:48:31 -0400
"H. Peter Anvin" <hpa@zytor.com> w
> > I'm not sure if it's time yet to make the bswap ones be exported,
> > as they would no longer be usable for those early machines.  X86
> > guys CC:d.
> 
> On i386 we still default to i386-compatible binaries; I *think* gcc
> has macros telling you if the user has used -march=i486 etc.

It is also not the kernels job to provide this sort of functionality to
userspace programs. At all. This is gcc/glibc/etc's job.

Rule of thumb: the kernel does not provide code for compiling inside
userspace programs.

(As opposed to providing datastructures that userspace programs can use
to talk to the kernel).



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
