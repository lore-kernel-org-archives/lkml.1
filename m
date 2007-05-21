Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXEUML5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXEUML5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXEUMLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:11:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33689 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755931AbXEUMLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:11:48 -0400
Date: Mon, 21 May 2007 14:11:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070521121139.GB8332@elf.ucw.cz>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171508.40202.lenb@kernel.org> <20070517215321.GC7336@elf.ucw.cz> <200705171842.44134.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705171842.44134.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-05-17 18:42:43, Len Brown wrote:
> > Something similar happened to me on XE3, yes.
> > 
> > (Actual values were different; BIOS specified critical temperature at
> > cca 95C, but hw killed the power at cca 83C. Setting critical trip
> > point at 80C made the problem go away.)
> 
> Great, please file a bug and include the acpidump from the XE3
> and we'll fix it, rather than supporting a bogus (manual) workaround for it.

It is few years since I do not have that XE3 machine.

> Of course if your system is running at 80*C and the hardware shuts
> off at 83*C, you may have a broken fan, or one clogged with dust...

It _did_ have broken fan. It also had broken trip points.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
