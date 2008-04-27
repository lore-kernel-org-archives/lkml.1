Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbYD0Kjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbYD0Kjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYD0Kjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:39:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2828 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752248AbYD0Kjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:39:46 -0400
Date: Sun, 27 Apr 2008 12:39:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] x86: Modify Kconfig to allow up to 4096 cpus
Message-ID: <20080427103933.GA5168@ucw.cz>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com> <20080426001549.014201000@polaris-admin.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426001549.014201000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-04-25 17:15:49, Mike Travis wrote:
>   * Increase the limit of NR_CPUS to 4096 and introduce a boolean
>     called "MAXSMP" which when set (e.g. "allyesconfig"), will set
>     NR_CPUS = 4096 and NODES_SHIFT = 9 (512).

Why is redundant option 'maxsmp' a good idea?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
