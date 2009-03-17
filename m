Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbZCQQS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbZCQQS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbZCQQSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:18:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757450AbZCQQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:18:33 -0400
Date: Tue, 17 Mar 2009 09:15:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org, r0bertz@gentoo.org, viro@ZenIV.linux.org.uk
Subject: Re: [GIT] /proc/*/task getdents fixlet
In-Reply-To: <20090317160638.GA2246@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0903170913250.3082@localhost.localdomain>
References: <20090317160638.GA2246@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Mar 2009, Alexey Dobriyan wrote:
> 
> Linus, please from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-linus
> 
> to get the following patch:
> 
> Zhang Le (1):
>       proc: update ->f_pos correctly in proc_task_readdir()

Grr. I already took the previous patch.

I assume the only difference is to avoid using a "switch()" on a 64-bit 
variable, and just cast it to "unsigned long". No?

		Linus
