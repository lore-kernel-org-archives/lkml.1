Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYHFWOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYHFWOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYHFWNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:13:47 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50606 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYHFWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:13:46 -0400
Message-ID: <489A221A.3030409@keyaccess.nl>
Date: Thu, 07 Aug 2008 00:13:46 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: does an initcall level of "0s" actually exist?
References: <alpine.LFD.1.10.0808051848330.19162@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0808051848330.19162@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-08-08 00:51, Robert P. J. Day wrote:

>   from include/asm-generic/vmlinux.lds.h:
> 
> #define INITCALLS                                                       \
>         *(.initcallearly.init)                                          \
>         VMLINUX_SYMBOL(__early_initcall_end) = .;                       \
>         *(.initcall0.init)                                              \
>         *(.initcall0s.init)                                             \
>         *(.initcall1.init)                                              \
>         *(.initcall1s.init)                                             \
> ... etc ...
> 
>   but from include/linux/init.h:
> 
> #define pure_initcall(fn)               __define_initcall("0",fn,0)
> 
> #define core_initcall(fn)               __define_initcall("1",fn,1)
> #define core_initcall_sync(fn)          __define_initcall("1s",fn,1s)
> #define postcore_initcall(fn)           __define_initcall("2",fn,2)
> #define postcore_initcall_sync(fn)      __define_initcall("2s",fn,2s)
> 
>   i don't see any initcalls of level "0s".  in any event, might it not
> be cleaner to have these files sync up?  no big deal, of course.  i'm
> well aware that it doesn't break anything.

Last I heard, all sync levels were on their way out (Arjan).

Rene.
