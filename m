Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbYDVBz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbYDVBz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYDVBzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:55:45 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:49966 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbYDVBzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:55:44 -0400
Date: Mon, 21 Apr 2008 21:55:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/8] omfs: add directory routines
Message-ID: <20080422015520.GB9591@hash.localnet>
References: <1208637457-24969-5-git-send-email-me@bobcopeland.com> <E1Jnxmc-0002xo-T8@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jnxmc-0002xo-T8@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:18:18PM +0200, Miklos Szeredi wrote:
> These are leaking the inode reference.
> 
> There's more like these in the patch, please check all
> omfs_new_inode() calls.

Er, yeah, that's embarrassing.  The other two are in omfs_create which
only differs from mkdir by a couple of lines; I should probably merge
them.

Thanks again for the review!

-- 
Bob Copeland %% www.bobcopeland.com 

