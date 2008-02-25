Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbYBYWUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbYBYWUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbYBYWUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:20:00 -0500
Received: from 1wt.eu ([62.212.114.60]:2125 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760528AbYBYWT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:19:58 -0500
Date: Mon, 25 Feb 2008 23:19:54 +0100
From: Willy Tarreau <w@1wt.eu>
To: Oleg Verych <olecom@gmail.com>
Cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20080225221953.GX8953@1wt.eu>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <8499950a0802251417l7a2fff25q7fa57fce57369b1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8499950a0802251417l7a2fff25q7fa57fce57369b1b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:17:23PM +0100, Oleg Verych wrote:
> On Mon, Feb 25, 2008 at 10:42 PM, Steve Brokenshire:
> > Hi,
> >
> >  (I've sent this to the linux-kbuild and linux-kernel lists as this
> >  patch modifies the Makefile.modinst file. I also don't subscribe to the
> >  linux-kbuild and linux-kernel mailing lists so can I have any replies
> >  CC'ed to me please)
> 
> And what if i like bzip2 (yea sometimes better) or 7zip (better if !EMBEDDED)
> or whatever?
> 
> It's pure user/distro question.

not exactly, as only gzip is supported by module-init-tools. However,
if you come up with a patch to implement lzma or equivalent for
module-init-tools, it may be useful.

Willy

