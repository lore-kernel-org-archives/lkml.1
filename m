Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZHPBhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZHPBhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 21:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZHPBhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 21:37:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:35806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbZHPBhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 21:37:35 -0400
Message-ID: <4A8762C7.7030505@kernel.org>
Date: Sun, 16 Aug 2009 10:37:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Guillaume Knispel <gknispel@proformatique.com>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] poll/select: initialize triggered field of struct poll_wqueues
References: <20090815193024.121926e6@xilun.lan.proformatique.com>	<4A875874.20401@kernel.org> <20090815181559.d73f0da6.akpm@linux-foundation.org>
In-Reply-To: <20090815181559.d73f0da6.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 01:37:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> OK, thanks.
> 
> I tagged this for -stable backporting.  That isn't strictly needed, as
> there's no particular harm caused here.  But using an uninitialised
> variable in the core poll/select code is pretty gross.

Yes, I was thinking about putting this for -stable too.  It's not
critical but still.

Thanks.

-- 
tejun
