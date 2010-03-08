Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0CHIth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 03:49:37 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:57910 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0CHItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 03:49:35 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [git pull] vfs patches, beginning
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100303222105.GU30031@ZenIV.linux.org.uk>
References: <20100303222105.GU30031@ZenIV.linux.org.uk>
Date: Mon, 08 Mar 2010 17:49:31 +0900
Message-ID: <6862.1268038171@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> 	Assorted stuff for that cycle, part 1.  There will be more tomorrow.
	:::
>       set S_DEAD on unlink() and non-directory rename() victims

If the inode is hardlinked, it will survive.
Is setting S_DEAD correct in such case?


J. R. Okajima
