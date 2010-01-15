Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0AOQyP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165Ab0AOQyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:54:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:58228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab0AOQyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:54:14 -0500
Date: Fri, 15 Jan 2010 17:54:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, sameo@linux.intel.com,
        Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] typo in kernel source (DEBUGFS)
In-Reply-To: <alpine.LRH.2.00.1001151500460.15694@twin.jikos.cz>
Message-ID: <alpine.LRH.2.00.1001151752550.15694@twin.jikos.cz>
References: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de> <63386a3d1001140207p5e2546fq2d8201ee87edfd46@mail.gmail.com> <alpine.LRH.2.00.1001151500460.15694@twin.jikos.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Jiri Kosina wrote:

> > 2010/1/13 Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>:
> > 
> > >        While working on this we detected a spelling error in
> > > drivers/mfd/ab3100-otp.c which can be corrected using the attached
> > > patch.
> > 
> > Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> 
> The original patch misses a Signed-off-by. Please resend it to 
> trivial@kernel.org with this line, so that it could be applied.

... and has this been tested at all?

drivers/mfd/ab3100-otp.c: In function ¡show_otp¢:
drivers/mfd/ab3100-otp.c:101: error: dereferencing pointer to incomplete type
drivers/mfd/ab3100-otp.c:104: error: implicit declaration of function ¡seq_printf¢
drivers/mfd/ab3100-otp.c:102: warning: unused variable ¡err¢
drivers/mfd/ab3100-otp.c: In function ¡ab3100_otp_open¢:
drivers/mfd/ab3100-otp.c:116: error: implicit declaration of function ¡single_open¢
drivers/mfd/ab3100-otp.c:116: error: ¡ab3100_otp_show¢ undeclared (first use in this function)
drivers/mfd/ab3100-otp.c:116: error: (Each undeclared identifier is reported only once
drivers/mfd/ab3100-otp.c:116: error: for each function it appears in.)
drivers/mfd/ab3100-otp.c: At top level:
drivers/mfd/ab3100-otp.c:121: error: ¡seq_read¢ undeclared here (not in a function)
drivers/mfd/ab3100-otp.c:122: error: ¡seq_lseek¢ undeclared here (not in a function)
drivers/mfd/ab3100-otp.c:123: error: ¡single_release¢ undeclared here (not in a function)
drivers/mfd/ab3100-otp.c: In function ¡ab3100_otp_init_debugfs¢:
drivers/mfd/ab3100-otp.c:134: error: ¡err¢ undeclared (first use in this function)
drivers/mfd/ab3100-otp.c: In function ¡ab3100_otp_exit_debugfs¢:
drivers/mfd/ab3100-otp.c:140: error: implicit declaration of function ¡debugfs_remove_file¢

So looks like the debugfs code might need some more surgery.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

