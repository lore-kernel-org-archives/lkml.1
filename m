Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZLNAVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZLNAVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbZLNAVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:21:42 -0500
Received: from [76.245.85.235] ([76.245.85.235]:39865 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZLNAVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:21:41 -0500
X-Greylist: delayed 1916 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2009 19:21:40 EST
Date: Sun, 13 Dec 2009 15:49:09 -0800
From: Brad Boyer <flar@allandria.com>
To: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       James Morris <jmorris@namei.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>, Chris Zankel <chris@zankel.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Keys: KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME architecture support
Message-ID: <20091213234909.GA10609@cynthia.pants.nu>
References: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg> <21796.1260743776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21796.1260743776@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 10:36:16PM +0000, David Howells wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > +#warning TIF_NOTIFY_RESUME not implemented
> > +	return -EOPNOTSUPP;
> 
> I wonder if it should printk() too.

I would think something like WARN_ONCE() or something rate limited would
be more appropriate.

	Brad Boyer
	flar@allandria.com

