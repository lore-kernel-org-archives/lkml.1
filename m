Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZJHLFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZJHLFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZJHLFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:05:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbZJHLE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 07:04:59 -0400
Date: Wed, 7 Oct 2009 11:44:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: don't leak kernel register values to 32-bit
	processes
Message-ID: <20091007094248.GA1425@ucw.cz>
References: <4AC34D73020000780001744A@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC34D73020000780001744A@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> While 32-bit processes can't directly access R8...R15, they can gain
> access to these registers by temporarily switching themselves into
> 64-bit mode. Therefore, registers not preserved anyway by called C
> functions (i.e. R8...R11) must be cleared prior to returning to user
> mode.

How can userspace "temporarily switch itself" to 64bit mode?

Such ability would lead to very interesting behaviour on 32-bit
kernel, I'd say...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
