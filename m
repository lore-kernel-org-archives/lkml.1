Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbZJHN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbZJHN1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbZJHN1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:27:42 -0400
Received: from mail2.shareable.org ([80.68.89.115]:33046 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbZJHN1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:27:42 -0400
Date: Thu, 8 Oct 2009 14:26:36 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfs: new O_NODE open flag
Message-ID: <20091008132636.GA29691@shareable.org>
References: <E1MvonW-0004rO-4A@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MvonW-0004rO-4A@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> There's been a fair amount of interest in the concept, but less actual
> review of the details.
> 
> Changes from the last posting:
> 
>  - make fchmod() fail on symlinks

fchmodat(2) says:

       AT_SYMLINK_NOFOLLOW
              If pathname is a symbolic link, do not dereference it:
              instead operate on the link itself.  This flag is not
              currently implemented.

If the flag were implemented, it would make sense for fchmod() on a
symlink to succeed, wouldn't it?

-- Jamie
