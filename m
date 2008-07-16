Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYGPQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYGPQyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYGPQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:54:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44921 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbYGPQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:54:08 -0400
Date: Wed, 16 Jul 2008 09:53:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: hpa <hpa@zytor.com>
Subject: Re: x86: move x86-specific documentation into Documentation/x86
Message-Id: <20080716095353.9c26a0c5.randy.dunlap@oracle.com>
In-Reply-To: <200807142239.m6EMdCED028677@hera.kernel.org>
References: <200807142239.m6EMdCED028677@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 22:39:12 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=23deb06821442506615f34bd92ccd6a2422629d7
> Commit:     23deb06821442506615f34bd92ccd6a2422629d7
> Parent:     4039feb5bae72a5fed9ba6bc1a9cfd8dfe0a8613
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Fri May 30 17:19:03 2008 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri May 30 17:19:03 2008 -0700
> 
>     x86: move x86-specific documentation into Documentation/x86
>     
>     The current organization of the x86 documentation makes it appear as
>     if the "i386" documentation doesn't apply to x86-64, which is does.
>     Thus, move that documentation into Documentation/x86, and move the
>     x86-64-specific stuff into Documentation/x86/x86_64 with the eventual
>     goal to move stuff that isn't actually 64-bit specific back into
>     Documentation/x86.

Thanks for doing this.

How about this also?

git mv Documentation/mtrr.txt Documentation/x86/mtrr.txt


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
