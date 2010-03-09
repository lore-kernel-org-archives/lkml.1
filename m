Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab0CIBz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:55:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56068 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab0CIBz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:55:26 -0500
Date: Tue, 9 Mar 2010 01:55:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Luca Barbieri <luca.barbieri@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100309015518.GS30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
 <20100308184521.GK30031@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
 <ff13bc9a1003081718k1e7964f5ta9e582866dea94ee@mail.gmail.com>
 <20100309012552.GR30031@ZenIV.linux.org.uk>
 <ff13bc9a1003081751s535fbf71l9d261b303587b23a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff13bc9a1003081751s535fbf71l9d261b303587b23a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 02:51:55AM +0100, Luca Barbieri wrote:
> >> 4. It doesn't matter at all if anyone reads a file that happens to be
> >> at /etc/shadow while not containing shadow passwords (with the same
> >> path, but different content)
> >
> > What the hell are you smoking?
> 
> I mean, what is interesting for security of reading is the fact that
> the file contains shadow passwords (and thus is labeled as "secret" or
> with a specific label), not that it is at /etc/shadow.

<sarcasm>
Yeah, especially when it's read by sshd.  Who cares, indeed?  So it's got
a passwordless root, that's even better, right?  Nobody will see your
real root password that way...
</sarcasm>
