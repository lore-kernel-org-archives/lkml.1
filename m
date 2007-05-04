Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXEDPAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXEDPAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbXEDPAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:00:00 -0400
Received: from gw.goop.org ([64.81.55.164]:49736 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbXEDO7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:59:52 -0400
Message-ID: <463B4A69.6020203@goop.org>
Date: Fri, 04 May 2007 07:59:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure
 for paravirtualization"
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>	<1178280770.23670.61.camel@localhost.localdomain> <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> It's not theatrical.  It makes this code path extremely brittle and
> very hard to change, which over the long term means that it is
> impossible to maintain.  Quickly resulting in a state where any little
> change will break something.

Removing the code now is premature.  I'm presuming you're proposing this
as a .23 change, since we're planning on changing the paravirt boot to
make use of bzImage and the boot protocol then anyway.

The world isn't going to fall apart if its in there for a couple of months.

    J
