Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYCXXFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYCXXFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYCXXFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:05:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:57036 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbYCXXFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:05:44 -0400
Date: Tue, 25 Mar 2008 02:04:58 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080324230458.GA173@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324223925.GD2426@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Pavel Machek wrote:
>
> > /sbin/init is important, but there are other important (and sometimes
> > much more important) services. Why it is so special so that we can't
> > debug/strace it?
> 
> Maybe. Let's kill /sbin/init protection in 2.6.26. But making it
> optional is wrong.

You are right, the boot parameter is silly. How about sysctl?

Stephen, do you see any security problems if we make /sbin/init
ptraceable by default?

Oleg.

