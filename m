Return-Path: <linux-kernel-owner+w=401wt.eu-S1161540AbXBHLU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161540AbXBHLU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422790AbXBHLU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:20:28 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53890 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161540AbXBHLU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:20:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <20070208094831.56920.qmail@web26908.mail.ukl.yahoo.com>
Date: Thu, 08 Feb 2007 04:20:10 -0700
In-Reply-To: <20070208094831.56920.qmail@web26908.mail.ukl.yahoo.com> (Etienne
	Lorrain's message of "Thu, 8 Feb 2007 09:48:31 +0000 (GMT)")
Message-ID: <m1odo4aob9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:

>> Currently relocation information is extracted from vmlinux and packed in
>> final bzImage after some processing. After execution of real mode code
>> and once the image is decompressed, all the relocations are performed and
>> then control is transferred to kernel.
>
>   So here you are not really using the initial ELF program header of vmlinux,
> but more the section header and my PT_LOAD section bother you, I better
> understand. You cannot really claim you are only doing standard/usual
> ELF treatment.

The difference is that a boot loader is not doing the work.  The format is.
Compiling -fPIC almost gets us there except ld has bugs processing absolute
symbols.

Anything we expect a bootloader to do need to be as close as possible to
the usual ELF treatment.

Eric
