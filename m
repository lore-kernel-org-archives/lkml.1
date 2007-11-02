Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbXKBVUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbXKBVUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761113AbXKBVUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:20:16 -0400
Received: from mail.trixing.net ([87.230.125.58]:53184 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760892AbXKBVUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:20:13 -0400
Message-ID: <472B9479.7040105@l4x.org>
Date: Fri, 02 Nov 2007 22:19:53 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <15675.1193753820@redhat.com> <4726337B.1080608@l4x.org> <4725B553.4060502@l4x.org> <4220.1193663179@redhat.com> <15712.1193753924@redhat.com>
In-Reply-To: <15712.1193753924@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.106
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: Working frv toolchain?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
>> Ah... I'd forgotten about that.  I'm not sure all the ASM constraint changes
>> are upstream yet, and gcc bz 28583 also gets incurred.  Are you particularly
>> interested in building your own compiler, or would one of ours do?
> 
> Look in:
> 
> 	ftp://ftp.redhat.com/pub/redhat/gnupro/FRV

Hrm, that gets me further, but one of the final stages fail:

   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
kernel/built-in.o(.text+0x2e684): In function `kallsyms_lookup_name':
: relocation truncated to fit: R_FRV_GPREL12 kallsyms_num_syms
kernel/built-in.o(.text+0x2e6d4): In function `kallsyms_lookup_name':
: relocation truncated to fit: R_FRV_GPREL12 kallsyms_num_syms
kernel/built-in.o(.text+0x2e750): In function `get_symbol_pos':
: relocation truncated to fit: R_FRV_GPREL12 kallsyms_num_syms
kernel/built-in.o(.text+0x2ed00): In function `update_iter':
: relocation truncated to fit: R_FRV_GPREL12 kallsyms_num_syms
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

Todays git tree. Is there any known good release I can test
this toolchain against?

Thanks,

Jan
