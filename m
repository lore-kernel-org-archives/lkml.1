Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYLNRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYLNRej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYLNRea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:34:30 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:52922 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbYLNRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FykKYDRfJkgxLgIB83HcIEShYmWQTRR8reeKSkgdl9MRqR+xkoD6vlRJzF/19xVPvk
         YaPqpI0w9c617JW2F3TMYnD8YPMyRPDXW/W2AX0J9BTdC2NrxSoDdX1NqIJQN2lrzRXT
         J8ZYYorUSHuhYtJji0GjkR//2IL94eUy39thY=
Date: Sun, 14 Dec 2008 18:33:50 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081214173152.GA6557@joi>
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 06:28:27PM +0000, David Howells wrote:
> +REVERTING COMMITTED CHANGES
> +---------------------------
> +
> +And sometimes you'll want to revert changes that you've committed, but that are
> +now buried beneath other commits.  Short of discarding and reapplying commits,
> +you have to apply a reverse patch:
> +
> +	git diff %COMMIT_ID | patch -p1 -R
> +
> +and then commit it.  Both the original application and the reversion will be
> +retained by GIT.

"git revert $commit" is a bit shorter.

Marcin
