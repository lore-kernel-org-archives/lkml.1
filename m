Return-Path: <linux-kernel-owner+w=401wt.eu-S935322AbYD1OzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322AbYD1OzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935229AbYD1Oyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:54:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2030 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935213AbYD1Oyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:54:37 -0400
Date: Mon, 28 Apr 2008 15:04:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: cleanup early per cpu variables/accesses v4-folded
Message-ID: <20080428130445.GA7113@ucw.cz>
References: <20080422204219.994283000@polaris-admin.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422204219.994283000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-04-22 13:42:19, Mike Travis wrote:
> 
>   * Increase the limit of NR_CPUS to 4096 and introduce a boolean
>     called "MAXSMP" which when set (e.g. "allyesconfig"), will set
>     NR_CPUS = 4096 and NODES_SHIFT = 9 (512).  Changed max setting
>     for NODES_SHIFT from 15 to 9 to accurately reflect the real limit.

NAK. Having redundant option sounds like a bad idea. What is it good
for?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
