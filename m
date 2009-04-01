Return-Path: <linux-kernel-owner+w=401wt.eu-S1764807AbZDAAHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764807AbZDAAHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbZDAAHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:07:10 -0400
Received: from thunk.org ([69.25.196.29]:38473 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZDAAHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:07:09 -0400
Date: Tue, 31 Mar 2009 20:06:57 -0400
From: Theodore Tso <tytso@mit.edu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Pavel Machek <pavel@ucw.cz>, Artem Bityutskiy <dedekind@yandex.ru>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in
	UBIFS)
Message-ID: <20090401000657.GH15063@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bodo Eggert <7eggert@gmx.de>, Pavel Machek <pavel@ucw.cz>,
	Artem Bityutskiy <dedekind@yandex.ru>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <ckjPq-2Dl-15@gated-at.bofh.it> <cl2jy-65z-1@gated-at.bofh.it> <cl2CZ-6q2-21@gated-at.bofh.it> <cl2N9-6Bj-9@gated-at.bofh.it> <E1LolUc-0003kM-FU@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LolUc-0003kM-FU@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 11:27:33PM +0200, Bodo Eggert wrote:
> This can be done using implicit logic:
> 
> ->E.g. on close(), mark inodes without being sync()ed as poisoned.
> (I can think of more sophisticated logic, but ...)
> ->On completing the inode with the delayed allocations, unpoison it.
> ->Don't commit rename()s if the corresponding inode is poisoned.

Send us patches if you think it's that easy to do what you are
proposing.   I assure it's not easy.

				- Ted
