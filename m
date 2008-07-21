Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYGUN1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYGUN1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYGUN0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:26:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59523 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYGUN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:26:55 -0400
Date: Mon, 21 Jul 2008 14:26:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] nfs: fix permission mask
Message-ID: <20080721132654.GF28946@ZenIV.linux.org.uk>
References: <E1KKtis-00089S-MU@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KKtis-00089S-MU@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 01:38:34PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Handle auxiliary mask bits in nfs_permission() properly.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Argh...  Applied, thanks.  Hrm...  On the next rebase I'd better move
it next to the patch introducing the breakage in question.  Or fold
it in, if you don't mind, with commit messages merged...
