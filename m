Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYDZNfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYDZNfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYDZNf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:35:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41390 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYDZNf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:35:29 -0400
Date: Sat, 26 Apr 2008 07:35:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches
Message-ID: <20080426133512.GP14990@parisc-linux.org>
References: <20080426020221.GF5882@ZenIV.linux.org.uk> <20080426110139.GA23867@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426110139.GA23867@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 01:01:39PM +0200, Ingo Molnar wrote:
> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> >      sanitize unshare_files/reset_files_struct
> 
> today's -git started crashing on me in randconfig boot tests:
> 
> [    0.124077] BUG: unable to handle kernel NULL pointer dereference at 00000296
> [    0.126981] IP: [<c01217fb>] put_files_struct+0xb/0xa0
> [    0.128981] *pdpt = 0000000000f73001 *pde = 0000000000000000
> [    0.131231] Oops: 0002 [#1] PREEMPT

Did you have http://lkml.org/lkml/2008/4/26/1 applied?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
