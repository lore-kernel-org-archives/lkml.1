Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZCLXjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZCLXjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZCLXji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:39:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCLXjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:39:37 -0400
Message-ID: <49B99D0E.8060507@zytor.com>
Date: Thu, 12 Mar 2009 16:38:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86: use targets in the boot Makefile instead
 of CLEAN_FILES
References: <tip-16a6791934a1077609482dd6c091aa8b4c39a834@git.kernel.org> <20090312210641.GC14205@uranus.ravnborg.org>
In-Reply-To: <20090312210641.GC14205@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> When you are cleaning up...
> 
> archclean:
>         $(Q)rm -rf $(objtree)/arch/i386
>         $(Q)rm -rf $(objtree)/arch/x86_64
> 
> Do we need this hack now?
> I recall it was some backward soon-to-be-removed hack we made right after the x86 merge.
> 

Well, the hack hasn't been removed at least not in that particular 
branch... we still create bzImage symlinks.

It would be nice to fix that, I agree, and that would clean up the 
Makefile further.

	-hpa


