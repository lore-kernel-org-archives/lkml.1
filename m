Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYG0D7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYG0D7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYG0D7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:59:38 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50664 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbYG0D7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:59:37 -0400
Date: Sun, 27 Jul 2008 04:59:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Kel Modderman <kel@otaku42.de>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: tmpfs: kernel BUG at mm/shmem.c:814
In-Reply-To: <20080727033137.GA3489@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0807270451250.5297@blonde.site>
References: <200807262210.11502.kel@otaku42.de> <Pine.LNX.4.64.0807262318050.25997@blonde.site>
 <20080727033137.GA3489@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 26 Jul 2008, Hugh Dickins wrote:
> > on 2.6.26.  It's using posix_fadvise on directories, and the shmem_readpage
> > method added in 2.6.23 is letting POSIX_FADV_WILLNEED allocate useless pages
> ...
> 
> > Cc: stable@kernel.org
> 
> Is the fix needed on 2.6.25 as well?

That's right: I introduced the bug in 2.6.23, so all since want the fix.

Hugh
