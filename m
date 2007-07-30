Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbXG3IDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbXG3IDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXG3IC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:02:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59879 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbXG3ICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:02:55 -0400
Date: Mon, 30 Jul 2007 13:33:03 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       jan.kratochvil@redhat.com
Subject: Re: [BUG] i386 relocable kernel breakes /proc/kcore debugging
Message-ID: <20070730080303.GA6071@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <200707280443.44048.maximlevitsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707280443.44048.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 04:43:43AM +0300, Maxim Levitsky wrote:
> Hello,
> 
> Today I noticed that gdb gets confused when I try to load a vmlinux image.
> gdb 'thinks' that all kernel symbols are below 0x80000000 , while they are at 
> 0xC000....
> 
> Turning CONFIG_RELOCATABLE off fixes that, so I assume that is the reason for 
> that.
> 

This is a gdb issue. I had raised it in gdb mailing list some time back.

http://sourceware.org/ml/gdb/2006-08/msg00137.html

What version of gdb you are using? I know it got fixed for gdb shipped
with RHEL5. I am not sure about what upstream version of gdb it got fixed
in.

I think Jan Kratochvil had put a patch to fix the issue. I am copying him
on the mail and he should be able to tell which version of gdb to use.

Thanks
Vivek
