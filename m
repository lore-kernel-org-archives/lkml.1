Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZLOPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZLOPQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZLOPQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:16:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbZLOPQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:16:15 -0500
Message-ID: <4B27A7CD.1040008@redhat.com>
Date: Tue, 15 Dec 2009 10:14:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com
Subject: Re: [RFC, PATCH 1/4] cleanup elf_core_dump(): remove ELF_CORE_EXTRA_*
 macro
References: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke HATAYAMA wrote:
> elf_core_dump() uses #ifdef and the corresponding macro for hiding
> _multiline_ logics in functions. This patch removes #ifdef and
> replaces ELF_CORE_EXTRA_* by corresponding functions. For
> architectures not implemeonting ELF_CORE_EXTRA_*, we use weak
> functions in order to reduce a range of modification.
> 
> This cleanup is for my next patches, but I think this cleanup itself
> is worth doing regardless of my firnal purpose.
> 
> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
> ---
>  arch/ia64/kernel/Makefile  |    2 +
>  arch/ia64/kernel/elfcore.c |   75 ++++++++++++++++++++++++++++++++++++++++++
>  arch/um/sys-i386/Makefile  |    2 +
>  arch/um/sys-i386/elfcore.c |   78 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/binfmt_elf.c            |   36 +++++++++++++++-----
>  include/linux/elf.h        |    2 +

Hmm, why don't you remove ELF_CORE_EXTRA_* macros too??
And also, you have to update fs/binfmt_elf_fdpic.c too.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

