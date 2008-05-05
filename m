Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbYEENFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbYEENFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbYEENFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:05:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYEENFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:05:13 -0400
Date: Mon, 5 May 2008 09:04:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: [patch 13/15] vfs: utimes cleanup
Message-ID: <20080505130447.GA18449@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095528.826574311@szeredi.hu> <20080505113042.GA28997@infradead.org> <E1Jszyt-0005wE-Ue@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jszyt-0005wE-Ue@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 02:39:47PM +0200, Miklos Szeredi wrote:
> > checks into it aswell, even if that means a little flag telling if
> > file->f_mode should be checked or vfs_permission().
> 
> How would that be better?  There's zero commonality between the two
> kinds of permission checks (other than utimes_need_permission()).

it looks very similar.  but actually given that the next patch removes
the IS_IMMUTABLE check in the fd case it isn't anymore.  You're probably
right that it doesn't make sense to move it to the common one.

