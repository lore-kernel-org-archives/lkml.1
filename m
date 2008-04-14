Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYDNJmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYDNJmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYDNJm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:42:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35792 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYDNJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:42:29 -0400
Date: Mon, 14 Apr 2008 10:42:15 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dwmw2@infradead.org, hch@infradead.org, akpm@linux-foundation.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080414094215.GD2076@shareable.org>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org,
	hch@infradead.org, akpm@linux-foundation.org, me@bobcopeland.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> And I didn't advocate moving
> ntfs to fuse, still that was done

Yes, that's quite annoying as FUSE doesn't work with my architecture,
so I can't use the only good NTFS driver.... grr! :-)

FUSE is great for user-mounted filesystems, though.  Having to use
"su" in shell scripts which modify loopback filesystems was always
very ugly.

I don't see why we need such a dichotomy, though.  The VFS API is
sensible enough that it should be possible to compile the same
filesystem code to run in kernel or in FUSE.

-- Jamie
