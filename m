Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbYETQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbYETQrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYETQrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:47:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43169 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbYETQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:47:00 -0400
Date: Tue, 20 May 2008 18:47:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
Message-ID: <20080520164758.GA8531@elf.ucw.cz>
References: <1211125094-32167-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211125094-32167-1-git-send-email-avi@qumranet.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-05-18 18:38:14, Avi Kivity wrote:
> The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
> pointers in order to trap erronous use of freed list_heads.  Unfortunately
> userspace can arrange for those pointers to actually be dereferencable,
> potentially turning an oops to an expolit.
> 
> To avoid this allow architectures (currently x86_64 only) to override
> the default values for these pointers with truly-undereferncable values.
> This is easy on x86_64 as the virtual address space is smaller than
> the range spanned by pointer values.

"Security hole unless arch maintainer does _foo_" sounds
scary. Especially when i386 is hard to fix...

(And very nice catch, btw).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
