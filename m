Return-Path: <linux-kernel-owner+w=401wt.eu-S933823AbZD3R77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbZD3R77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934342AbZD3R64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:58:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34518 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934336AbZD3R6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:58:54 -0400
Date: Thu, 30 Apr 2009 20:01:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       monstr@monstr.eu, remis.developer@googlemail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/27] asm-generic: add generic versions of common headers
Message-ID: <20090430180104.GB9894@uranus.ravnborg.org>
References: <cover.1241105648.git.arnd@arndb.de> <265d330107973ffda3b4b8a3c26ec93f31dfdf00.1241105648.git.arnd@arndb.de> <20090430.094129.39981996.davem@davemloft.net> <200904301849.45543.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301849.45543.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 06:49:44PM +0200, Arnd Bergmann wrote:
> On Thursday 30 April 2009, David Miller wrote:
> > Many sites are bouncing because the date on your emails is
> > as much as two days in the past.
> 
> Any suggestions on which tool I should use? I've been burned by
> both 'quilt mail' and 'git-format-patch' this week and don't want
> to make any more experiments. I looked at git-send-email, but
> I'm sure I'd screw up even more with that because it directly
> sends out the patches rather than giving me an mbox file to look
> at.

I have been very pleased with git send-email.

I always send out the initial mail by hand "[PATCH 0/nn] xxx".
When it has arrived I create a small shell script
so I can handcraft the options.
Typical shell script looks like this:

git send-email --quiet --no-chain-reply-to \
--in-reply-to "<20090429073510.GA26386@uranus.ravnborg.org>" \
--to "Ingo Molnar <mingo@elte.hu>" \
--to "LKML <linux-kernel@vger.kernel.org>" \
00*

This works well when I have longer series of mail.
And you can split it up so you do it in smaller
groups of say 10 mails.

For a single patch or two I always do it manually.

	Sam
