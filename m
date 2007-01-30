Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbXA3W4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbXA3W4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXA3W4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:56:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXA3W4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:56:45 -0500
Date: Tue, 30 Jan 2007 14:55:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bodo Eggert <7eggert@gmx.de>
cc: akpm@osdl.org, Jeff Layton <jlayton@redhat.com>, dev@sw.ru,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] pipefs unique inode numbers
In-Reply-To: <Pine.LNX.4.58.0701302314210.2203@be1.lrz>
Message-ID: <Pine.LNX.4.64.0701301454400.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.58.0701302314210.2203@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jan 2007, Bodo Eggert wrote:
>
> change pipefs to use a unique inode number equal to the memory
> address unless it would be truncated.

I *really* wouldn't want to expose kernel addresses to user space, it just 
ends up being a piece of data that they shouldn't have. If we have some 
security issue, this is just too much kernel information that a bad user 
could get at.

		Linus
