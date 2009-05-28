Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbZE1GlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbZE1GlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZE1Gky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:40:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbZE1Gkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:40:52 -0400
Date: Wed, 27 May 2009 23:38:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Ky Srinivasan <ksrinivasan@novell.com>,
       Beulich <jbeulich@novell.com>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
Message-Id: <20090527233807.e7e39e97.akpm@linux-foundation.org>
In-Reply-To: <20090528072844.4c1db656@lxorguk.ukuu.org.uk>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
	<1243409850-21577-18-git-send-email-jeremy@goop.org>
	<alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
	<20090527211828.GA6166@elte.hu>
	<alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
	<adavdnm5hkx.fsf@cisco.com>
	<20090528072844.4c1db656@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 07:28:44 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I could see adding a tag along the lines of tested-by, reported-by,
> > reviewed-by, etc.  Maybe something like
> > 
> >     Closes-bug: <URL>
> 
> That would be useful and speed up closing bugs from changelogs. Right now
> thats a grep and human task.

Yup.  I presently use "Addresses: <url>" in the changelog.

y:/usr/src/git26> git-log | grep '^    Addresses.*bugzilla' | wc -l
36

Formalising that a bit more would be good.

Not all patches literally "close" a bugzilla report though.  Sometimes
there's related info in bugzilla but the bug remains.  But
"closes-bug:" is close enough.

