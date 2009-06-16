Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbZFPRbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbZFPRbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbZFPRbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:31:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46883 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZFPRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:31:05 -0400
Date: Tue, 16 Jun 2009 18:31:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: hooanon05@yahoo.co.jp
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches, part 1
Message-ID: <20090616173101.GG8633@ZenIV.linux.org.uk>
References: <20090612014507.GA8633@ZenIV.linux.org.uk> <11056.1245169149@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11056.1245169149@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:19:09AM +0900, hooanon05@yahoo.co.jp wrote:

> These two patches conflict, or are unmatched.
> Al's patch adds one lock_kernel() call and several unlock_kernel() into
> do_remount_sb(), and then Alessio's patch removes only single pair of
> lock/unlock_kernel().
> Finally a few unlock_kernel() are left in do_remount_sb().

Nice catch...

Applied, will push today.
