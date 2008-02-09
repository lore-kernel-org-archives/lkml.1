Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYBINTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYBINTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYBINSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:18:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3683 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753873AbYBINSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:18:51 -0500
Date: Sat, 9 Feb 2008 13:18:39 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] x86: add code to dump the (kernel) page tables for visual inspection
Message-ID: <20080209131838.GC5139@ucw.cz>
References: <20080204222641.4488e6a7@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204222641.4488e6a7@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-04 22:26:41, Arjan van de Ven wrote:
> Subject: x86: add code to dump the (kernel) page tables for visual inspection by kernel developers
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> This patch adds code to the kernel to have an (optional)
> /proc/kernel_page_tables debug file that basically dumps the kernel

'No new crap goes to /proc?'

It does not seem to be per process -> it should probably go to
debugfs.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
