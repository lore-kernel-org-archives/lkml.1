Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYBRJgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYBRJgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYBRJgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:36:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57387 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbYBRJgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:36:35 -0500
Date: Mon, 18 Feb 2008 01:34:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Lim <jlim@sgi.com>
Subject: Re: 2.6.25-rc2-mm1
Message-Id: <20080218013434.3479fb58.akpm@linux-foundation.org>
In-Reply-To: <20080217161619.c2629776.randy.dunlap@oracle.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080217161619.c2629776.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 16:16:19 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> Building i386 kernel on x86_64, I see a build error in linking:
> 
> kernel/built-in.o: In function `jiffies_64_to_usecs':
> (.text+0xeaed): undefined reference to `__udivdi3'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> .config attached.
> 

Thanks - that'll be provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
