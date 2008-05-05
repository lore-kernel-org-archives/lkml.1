Return-Path: <linux-kernel-owner+w=401wt.eu-S1765039AbYEESqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765039AbYEESqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762585AbYEESeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:34:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48415 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675AbYEESeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:34:22 -0400
Date: Mon, 5 May 2008 19:34:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Enrico Weigelt <weigelt@metux.de>
Cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505183420.GQ5882@ZenIV.linux.org.uk>
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu> <20080505174048.GP5882@ZenIV.linux.org.uk> <20080505182308.GG32019@nibiru.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505182308.GG32019@nibiru.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 08:23:09PM +0200, Enrico Weigelt wrote:

> Assuming the server doesn't resolve symlinks itself,

Um...  What the hell are you talking about?  How _can_ server resolve
symlinks, when result of symlink resolution depends on where the damn
thing is mounted on client and even how deeply the process trying to
do lookup happens to be chrooted?

It wouldn't work even for relative symlinks - remember that we might
bloody well have something bound on the middle of the path in question.
Without any knowledge by fs.

> Naive question: is it really *necessary* to have all the 
> intermediate dirs in dcache ?

The answer's "yes".
