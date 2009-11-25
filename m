Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbZKYIsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbZKYIsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:48:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbZKYIsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:48:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43851 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426AbZKYIr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:47:58 -0500
Date: Wed, 25 Nov 2009 09:48:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091125084804.GE29096@one.firstfloor.org>
References: <20091123145409.GA29627@wotan.suse.de> <87einnwsxv.fsf@basil.nowhere.org> <20091125065412.GD17484@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125065412.GD17484@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No that's what I meant, the new type would be non nestable.

Okay.  Unfortunately it's still quite a lot of work.

%git/linux-2.6> gid rwlock_t | wc -l
221

Just tasklist_lock alone would be tough I guess, on level with one of your
nasty VFS locks that protect a thousand different things without any
comments.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
