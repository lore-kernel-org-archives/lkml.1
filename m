Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbXFROCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbXFROCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762614AbXFROCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:02:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47732 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755786AbXFROCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:02:15 -0400
Date: Mon, 18 Jun 2007 16:02:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: holzheu <holzheu@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070618140205.GH1803@elf.ucw.cz>
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613111549.db1fa4d9.akpm@linux-foundation.org> <20070614094128.GF17819@atrey.karlin.mff.cuni.cz> <20070615124034.GH9442@ucw.cz> <1182174154.11400.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182174154.11400.57.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 'lp%d: on fire' -> 'your printer failed basic tests, you should check
> > cabling'.
> 
> Hmmm... What about extracting all format strings from the KMSG_DOC
> macros and storing them in a file. E.g.:
> 
>   printk("lp%d: on fire");
> 
>   /**
>    * message
>    *
>    * Description:
>    * Your printer failed basic tests, you should check cabling
>    ...
> 
>   KMSG_DOC(lp, "lp%d: on fire");

Yes, that was the idea. But we have already tools and standard format
for this (gettext), we should just use that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
