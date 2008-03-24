Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYCXXUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYCXXUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYCXXT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:19:56 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56786 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbYCXXTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:19:55 -0400
Date: Tue, 25 Mar 2008 02:18:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080324231859.GA193@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru> <20080324230930.GE2426@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324230930.GE2426@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Pavel Machek wrote:
>
> On Tue 2008-03-25 02:04:58, Oleg Nesterov wrote:
> > On 03/24, Pavel Machek wrote:
> > >
> > > > /sbin/init is important, but there are other important (and sometimes
> > > > much more important) services. Why it is so special so that we can't
> > > > debug/strace it?
> > > 
> > > Maybe. Let's kill /sbin/init protection in 2.6.26. But making it
> > > optional is wrong.
> > 
> > You are right, the boot parameter is silly. How about sysctl?
> 
> I'd prefer it to be hardcoded, really.

Yes! me too.

> "You can kill /sbin/init" sounds right.
> 
> "You can kill /sbin/init on 2.6.26+" sounds... still quite ok.
> 
> "You can kill /sbin/init on 2.6.26+ if you have /proc/sys/foo/bar ==
> 1" sounds... quite wrong.

Please look at another discussion, http://marc.info/?t=120568298600007

When I did this simple patch, I was very sure it is "obviously good".
But as Stephen pointed out, we have the systems that relies on the
current behaviour, even if this behaviour is not "optimal".

Oleg.

