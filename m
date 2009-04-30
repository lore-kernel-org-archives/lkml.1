Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbZD3Oz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbZD3Oz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762723AbZD3OzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:55:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282AbZD3OzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:55:04 -0400
Message-ID: <49F9BB47.7080806@zytor.com>
Date: Thu, 30 Apr 2009 07:52:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       jdb@comx.dk, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: boot/compressed/vmlinux.lds.S: fix build
 of bzImage with 64 bit compiler
References: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain> <tip-83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f@git.kernel.org>
In-Reply-To: <tip-83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Sam Ravnborg wrote:
> Commit-ID:  83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f
> Gitweb:     http://git.kernel.org/tip/83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f
> Author:     Sam Ravnborg <sam@ravnborg.org>
> AuthorDate: Thu, 30 Apr 2009 12:03:16 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 30 Apr 2009 12:36:50 +0200
> 
> x86: boot/compressed/vmlinux.lds.S: fix build of bzImage with 64 bit compiler
> 
> Jesper reported that he saw following build issue:
> 
>  > ld:arch/x86/boot/compressed/vmlinux.lds:9: syntax error
>  > make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
>  > make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
>  > make: *** [bzImage] Error 2
> 
> CPP defines the symbol "i386" to "1".
> Undefine this to fix it.
> 

I'm wondering if we should build the *.lds.S with -ansi or some other
gcc option which disables ALL non-underscore macros.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

