Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZCLVE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZCLVE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZCLVEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:04:48 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:44477 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZCLVEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:04:47 -0400
Date: Thu, 12 Mar 2009 22:06:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86: use targets in the boot Makefile instead of CLEAN_FILES
Message-ID: <20090312210641.GC14205@uranus.ravnborg.org>
References: <tip-16a6791934a1077609482dd6c091aa8b4c39a834@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-16a6791934a1077609482dd6c091aa8b4c39a834@git.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 08:48:28PM +0000, H. Peter Anvin wrote:
> Commit-ID:  16a6791934a1077609482dd6c091aa8b4c39a834
> Gitweb:     http://git.kernel.org/tip/16a6791934a1077609482dd6c091aa8b4c39a834
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Thu, 12 Mar 2009 13:43:14 -0700
> Commit:     H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 12 Mar 2009 13:43:14 -0700
> 
> x86: use targets in the boot Makefile instead of CLEAN_FILES
> 
> Impact: cleanup
> 
> Instead of using CLEAN_FILES in arch/x86/Makefile, add generated files
> to targets in arch/x86/boot/Makefile, so they will get naturally
> cleaned up by "make clean".
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Acked-by: Sam Ravnborg <sam@ravnborg.org>

When you are cleaning up...

archclean:
        $(Q)rm -rf $(objtree)/arch/i386
        $(Q)rm -rf $(objtree)/arch/x86_64

Do we need this hack now?
I recall it was some backward soon-to-be-removed hack we made right after the x86 merge.

	Sam
