Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbYEQXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbYEQXMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 19:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYEQXMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 19:12:10 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:38888 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751898AbYEQXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 19:12:09 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Date: Sun, 18 May 2008 00:12:04 +0100
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com,
       Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805172109.59244.alistair@devzero.co.uk> <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805180012.05011.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 May 2008 22:17:37 Linus Torvalds wrote:
[snip]
> Jens, there's been a *lot* of breakage in the block layer. The DMA bounce
> buffer crap, and this looks like the atomic bit setting was broken too.
>
> Alistair, does the problem go away if you revert both the patch from Neil
> and the original patch that caused the need for that patch to begin with
> (ie commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e "block: make queue
> flags non-atomic").

I did a git revert on this and manually fixed up the conflicts; I also 
reverted Neil's patch.

Unfortunately (though the WARNING is still gone) it doesn't fix the hang.

> Jens, Nick, I think that whole series just needs to be undone.
>
> 		Linus

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
