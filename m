Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbXJ0UsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbXJ0UsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXJ0UsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:48:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58920 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbXJ0UsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:48:06 -0400
Date: Sat, 27 Oct 2007 16:47:33 -0400
Message-Id: <200710272047.l9RKlXAo032686@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-reply-to: Your message of "Thu, 25 Oct 2007 19:03:14 BST."
             <Pine.LNX.4.64.0710251743190.9834@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0710251743190.9834@blonde.wat.veritas.com>, Hugh Dickins writes:
> On Mon, 22 Oct 2007, Erez Zadok wrote:
[...]
> > If you've got suggestions how I can handle unionfs_write more cleanly, or
> > comments on the above possibilities, I'd love to hear them.
> 
> For now I think you should pursue the ~(__GFP_FS|__GFP_IO) idea somehow.
> 
> Hugh

Hugh, thanks for the great explanations and suggestions (in multiple
emails).  I'm going to test all of those soon.

Erez.
