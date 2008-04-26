Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYDZTD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYDZTD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbYDZTDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:03:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:58082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753831AbYDZTDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:03:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19b48gJxB9bL2TH+7d0k9dYnvGVaspCwovCJdddAf
	AFTUrqIKSuPL9c
Subject: Re: [git pull] VFS patches
From: Mike Galbraith <efault@gmx.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080426133512.GP14990@parisc-linux.org>
References: <20080426020221.GF5882@ZenIV.linux.org.uk>
	 <20080426110139.GA23867@elte.hu>  <20080426133512.GP14990@parisc-linux.org>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 21:02:54 +0200
Message-Id: <1209236574.4830.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-26 at 07:35 -0600, Matthew Wilcox wrote:
> On Sat, Apr 26, 2008 at 01:01:39PM +0200, Ingo Molnar wrote:
> > 
> > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > >      sanitize unshare_files/reset_files_struct
> > 
> > today's -git started crashing on me in randconfig boot tests:
> > 
> > [    0.124077] BUG: unable to handle kernel NULL pointer dereference at 00000296
> > [    0.126981] IP: [<c01217fb>] put_files_struct+0xb/0xa0
> > [    0.128981] *pdpt = 0000000000f73001 *pde = 0000000000000000
> > [    0.131231] Oops: 0002 [#1] PREEMPT
> 
> Did you have http://lkml.org/lkml/2008/4/26/1 applied?

(Al: fixed my crash report as well)

