Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbXISQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbXISQh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbXISQhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:37:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:45979 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672AbXISQhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:37:16 -0400
In-Reply-To: <20070919092848.GG973@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919092848.GG973@shadowen.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <24129b460390d93b37ee4cf21d6a5db1@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: 2.6.23-rc6-mm1 -- powerpc link failure
Date: Wed, 19 Sep 2007 18:36:29 +0200
To: Andy Whitcroft <apw@shadowen.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I am seeing this strange link error from a PowerMac G5 (powerpc):
>
>   [...]
>     KSYM    .tmp_kallsyms2.S
>     AS      .tmp_kallsyms2.o
>     LD      vmlinux.o
>   ld: dynreloc miscount for fs/built-in.o, section .opd
>   ld: can not edit opd Bad value
>   make: *** [vmlinux.o] Error 1
>
> Compiler version below.

It's an ld error, could you show us your ld version instead?  And
please try with current mainline ld, too?


Segher

