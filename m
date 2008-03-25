Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbYCYV2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbYCYV2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760451AbYCYV2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:28:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36405 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760433AbYCYV2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:28:11 -0400
Date: Tue, 25 Mar 2008 21:11:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
Cc: "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: gcc-4.3 considers unaligned accesses on X86 as undefined
Message-ID: <20080325211102.44aa7ce7@core>
In-Reply-To: <47E965BD.7010604@gmail.com>
References: <47E965BD.7010604@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 22:51:09 +0200
Török Edwin <edwintorok@gmail.com> wrote:

> Hello x86 architecture maintainers,
> 
> GCC-4.3 now considers that it is undefined behaviour to access memory
> through an int*  that is not aligned to sizeof(int).
> At -O3 it generates vectorized code 

FPU/MMX/SSE are not available or usable for the kernel anyway fortunately
in this case.

Alan
