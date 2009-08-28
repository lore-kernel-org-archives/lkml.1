Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZH1IXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZH1IXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZH1IXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:23:22 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:51000 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbZH1IXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:23:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-2
X-IronPort-AV: E=Sophos;i="4.44,290,1249250400";   d="scan'208";a="23961300"
Message-id: <4A9793CF.6010406@nets.rwth-aachen.de>
Date: Fri, 28 Aug 2009 10:22:39 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31-rc8
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Linus Torvalds wrote.
> This should be the last -rc, and it's really been quieting down. There's 
> 131 commits there, and it's all pretty trivial. For example, in the 
> dirstat below, most of the arch/x86 changes are due to some vmlinux.lds.S 
> changes to fix problems with older binutils, not actual code changes. And 
> on powerpc, it's all the ps3 defconfig update.

I wonder why the one liner
http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=d560bc61575efae43595cbcb56d0ba3b9450139c
did not went in. It fixes a regression from 2.6.30:
http://bugzilla.kernel.org/show_bug.cgi?id=14062

Best regards,
Arnd


