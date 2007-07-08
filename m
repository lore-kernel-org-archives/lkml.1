Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbXGHSe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbXGHSe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXGHSes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:34:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36434 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbXGHSes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:34:48 -0400
Date: Sun, 8 Jul 2007 19:34:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference - git-bisect result
Message-ID: <20070708183445.GK21668@ftp.linux.org.uk>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk> <469121DA.6030600@redhat.com> <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org> <alpine.LFD.0.999.0707081126260.31544@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707081126260.31544@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 11:30:15AM -0700, Linus Torvalds wrote:
>  - non-owners can set it only when they have write permissions, and if it 
>    was a file descriptor, the only way for us to know that they have write 
>    permissions is if it's opened writably, which is hopefully equivalent 
>    to that MAY_WRITE test (except the MAY_WRITE test was done at _open_ 
>    time).
> 
> This would seem to be the minimal change, and I think it's right.

Yeah, FMODE_WRITE is probably right.
