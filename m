Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZGFSFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZGFSFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZGFSFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:05:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56226 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZGFSFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:05:09 -0400
To: npiggin@suse.de
CC: linux-fsdevel@vger.kernel.org, hch@infradead.org, jack@suse.cz,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20090706165522.GR2714@wotan.suse.de> (message from Nick Piggin
	on Mon, 6 Jul 2009 18:55:22 +0200)
Subject: Re: [rfc][patch 2/3] fs: make use of new helper functions
References: <20090706165438.GQ2714@wotan.suse.de> <20090706165522.GR2714@wotan.suse.de>
Message-Id: <E1MNsYt-0002N5-KE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Jul 2009 20:05:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Nick Piggin wrote:
> Update some fs code to make use of new helper functions introduced
> in the previous patch. Should be no significant change in behaviour
> (except CIFS now calls send_sig under i_lock, via inode_truncate_ok).

ACK for the fuse parts.

I think even the "if (newsize < oldsize)" conditionals could be
removed before calling truncate_pagecache() as that check is performed
inside truncate_pagecache().

Thanks,
Miklos
