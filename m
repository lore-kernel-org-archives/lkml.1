Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915AbZCIFq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbZCIFq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 01:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZCIFqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 01:46:47 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37389 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZCIFqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 01:46:47 -0400
Date: Mon, 9 Mar 2009 06:48:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Aufs 01/25] aufs documents
Message-ID: <20090309054842.GA14122@uranus.ravnborg.org>
References: <1236569118-3750-1-git-send-email-hooanon05@yahoo.co.jp> <1236569118-3750-2-git-send-email-hooanon05@yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236569118-3750-2-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 12:24:54PM +0900, J. R. Okajima wrote:
> initial commit
> design and manual
> 
> Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> ---

Documention seems impressive!
But your changelogs are in the contrary very sparse.

>  fs/Kconfig                                         |    1 +
>  fs/Makefile                                        |    1 +
The changes in the above files breaks bisectability.
You just broke "make oldconfig".


>  fs/namei.c                                         |    4 +-
>  fs/splice.c                                        |   10 +-
>  include/linux/namei.h                              |    3 +
>  include/linux/splice.h                             |    6 +
The changes to files outside fs/aufs2 needs to be justified in your changelog.
And they do not belong in this patch.

	Sam
