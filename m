Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbYETIiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbYETIiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbYETIhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:37:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbYETIhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:37:52 -0400
Date: Tue, 20 May 2008 01:37:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/57] watchdog: Giant scrub
Message-Id: <20080520013713.a58b3afd.akpm@linux-foundation.org>
In-Reply-To: <20080520080110.GA2724@infomag.infomag.iguana.be>
References: <20080519124659.31722.51847.stgit@core>
	<20080519112148.4d078ad4.akpm@linux-foundation.org>
	<20080520080110.GA2724@infomag.infomag.iguana.be>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 10:01:10 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Andrew,
> 
> > eek.
> > 
> > This comes at a time when git-watchdog has
> > 
> > and hasn't had a commit in six weeks, missed the merge window and the
> > most recent commit is titled "[WATCHDOG] rc32434_wdt: critical
> > bugfixes".
> > 
> > Wim, come back!
> > 
> > (Happily there appears to be little overlap between the two diffstats there)
> 
> Sorry guys, I had to do electricity, ... for the new house. I have to finish
> still one thing tonight and then things should be normal again for a few weeks.
> I indeed have some backlog, but Alan's patches seems rather straight forward.
> I'll merge them in the linux-watchdog-mm tree as soon as possible (but i'll first
> sent some watchdog patches over to linus because I seemed to have missed allready
> 2 rc releases :-( ).

Thanks, no probs.  Linus may get grumpy, but he hopefully doesn't know
where you live ;)

Please do take a look at the itco_wdt-ich9do-support.patch and
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch which I just
resent.  And we need to work out what to do about the Rusty problem,
which is also a linux-next problem.

