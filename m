Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760027AbYLQHuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbYLQHuN (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYLQHt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:49:58 -0500
Received: from tundra.namei.org ([65.99.196.166]:3340 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYLQHt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:49:58 -0500
Date: Wed, 17 Dec 2008 18:49:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] audit rules ordering, part 2
In-Reply-To: <E1LCoiS-0000FI-U8@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812171848510.22856@tundra.namei.org>
References: <E1LCoiS-0000FI-U8@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> 
> Fix the actual rule listing; add per-type lists _not_ used for matching,
> with all exit,... sitting on one such list.  Simplifies "do something
> for all rules" logics, while we are at it...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
