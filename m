Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbXJWXoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbXJWXoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXJWXn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:43:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733AbXJWXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:43:56 -0400
Date: Tue, 23 Oct 2007 16:43:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx>
Message-ID: <alpine.LFD.0.999.0710231641480.30120@woody.linux-foundation.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2007, Matthew Wilcox wrote:
>
> This is a generic string buffer which can also be used for non-printk
> purposes.  There is no sb_scanf implementation yet as I haven't identified
> a user for it.

Hmm. Have you looked at the git "strbuf" code? 

And stuff like "sb_string()" are just evil. The string is there. Just call 
it something better than "s", and let people just use "sb->buf" or 
something. Why make the interface harder to use than necessary?

			Linus
