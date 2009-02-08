Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZBHILF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZBHILF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 03:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZBHIKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 03:10:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55010 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZBHIKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 03:10:53 -0500
Date: Sun, 8 Feb 2009 09:10:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: lenb@kernel.org, gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 1/1] x86_64: acpi/wakeup_64 cleanup
Message-ID: <20090208081026.GB8040@elf.ucw.cz>
References: <1234028641-5072-1-git-send-email-jirislaby@gmail.com> <1234043558-15784-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234043558-15784-1-git-send-email-jirislaby@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-02-07 22:52:38, Jiri Slaby wrote:
> - remove %ds re-set, it's already set in wakeup_long64
> - remove double labels and alignment (ENTRY already adds both)
> - use meaningful resume point labelname
> - skip alignment while jumping from wakeup_long64 to the resume point
> - remove .size, .type and unused labels
> [v2]
> - added ENDPROCs
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Len Brown <lenb@kernel.org>

Acked-by: Pavel Machek <pavel@suse.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
