Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbZDIVVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbZDIVVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZDIVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:20:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbZDIVU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:20:59 -0400
Date: Thu, 9 Apr 2009 14:18:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <11730.1239311156@redhat.com>
Message-ID: <alpine.LFD.2.00.0904091412060.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <11730.1239311156@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, David Howells wrote:
> I should've used:
> 
> 	stg mail -diff-opts=-M
> 
> it would appear.  I wonder if this should be the default.

Ahh. I've never used stg. It seems to have some bad defaults.

Also, depending on exactly what "stg" does, it is entirely possible that 
adding that

	[diff]
		renames

to your .gitconfig won't help: those kinds of default configuration values 
are (very much on purpose) ignored for certain low-level git commands, 
exactly so that you can do reliable scripting without having to worry 
about some user-specific config files.

> Note that
> 
> 	git-diff -M HEAD^ HEAD
> 
> does not make output that looks like yours.  It's missing the:
> 
> 	 {include/asm-frv => arch/frv/include/asm}/Kbuild   |    0
> 	 {include/asm-frv => arch/frv/include/asm}/atomic.h |    0

Those come from "--summary", which summarizes file creation, deletion and 
movement. Almost always combined with "--stat", but apparently the 
"--stat" part is again in that "stg mail" script.

			Linus
