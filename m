Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbZDHOS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbZDHOS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933653AbZDHOOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:14:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbZDHOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:14:37 -0400
Date: Wed, 8 Apr 2009 11:13:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joe Perches <joe@perches.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
Message-ID: <20090408111344.56818f9e@pedra.chehab.org>
In-Reply-To: <1239167872-8179-3-git-send-email-joe@perches.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	<1239167872-8179-3-git-send-email-joe@perches.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Apr 2009 22:17:44 -0700
Joe Perches <joe@perches.com> wrote:

> Better description of file pattern tag "F:"
> Add file exclusion tag "X:"
> Add patterns to sections
> 
> Signed-off-by: Joe Perches <joe@perches.com>

>  DVB SUBSYSTEM AND DRIVERS
>  P:	LinuxTV.org Project
>  M:	linux-media@vger.kernel.org
>  W:	http://linuxtv.org/
>  T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>  S:	Maintained
> +F:	Documentation/dvb/
> +F:	drivers/media/dvb/
> +F:	drivers/media/common/saa7146*.c
> +F:	include/linux/dvb/

>  VIDEO FOR LINUX (V4L)
>  P:	Mauro Carvalho Chehab
>  M:	mchehab@infradead.org
>  L:	linux-media@vger.kernel.org
>  W:	http://linuxtv.org
>  T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>  S:	Maintained
> +F:	Documentation/video4linux/
> +F:	drivers/media/video/
> +F:	drivers/media/radio/
> +F:	include/linux/videodev.h
> +F:	include/linux/videodev2.h
> +F:	include/media/

For those two:
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

While those two entries are correct, they don't cover all files, since there
are other common drivers and core modules shared between both subsystems. For
example, the tuner and IR files are under drivers/media/common.

IMO, we should add a more generic entry to cover both. Something like:

MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
P:	Mauro Carvalho Chehab
M:	mchehab@infradead.org
L:	linux-media@vger.kernel.org
W:	http://linuxtv.org
T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
S:	Maintained
F:	drivers/media

Cheers,
Mauro
