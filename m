Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbZLFTIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbZLFTIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbZLFTIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:08:21 -0500
Received: from mail.perches.com ([173.55.12.10]:1071 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbZLFTIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:08:20 -0500
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warning about leading 
 contination tests
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andy Whitcroft <apw@canonical.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>
In-Reply-To: <20091206195345.0c7d188a@hyperion.delvare>
References: <1260035884.11126.58.camel@Joe-Laptop.home>
	 <4B1B6CB8.7000107@gmail.com> <20091206131324.55436006@hyperion.delvare>
	 <1260121576.11126.83.camel@Joe-Laptop.home>
	 <20091206195345.0c7d188a@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 11:08:26 -0800
Message-ID: <1260126506.11126.110.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 19:53 +0100, Jean Delvare wrote:
> I want to be able to tell
> people who submit patches to me: "run checkpatch.pl on your patch and
> solve every problem it reports before sending it to me again". If I
> must instead tell them: "run checkpatch.pl on your patch and fix what
> you want" then they might as well not fix anything, because they will
> not know which warnings _I_ find relevant and which I don't. Then the
> checkpatch.pl script becomes useless for that use case.

If you actually do that, you probably want them
to fix _every last problem_ because the patch is
either trivial or has so many broken elements
that asking that contributor to fix them all is
a learning experience for them.

> So if you are going to add checks which are icing on the cake, please
> disable them by default and only show them if the user explicitly asks

Making the test use the CHK function rather
than WARNING one seems sensible.

> > I think it's rather like the long line, >80
> > column warning.  There are a whole lot more
> > than 8k long lines in kernel source and no
> > one is suggesting reformatting all of them
> > out of existence.
> 
> Lines longer than 8_k_? I hope not ;)

Interpretive reading is like interpretive dance.
I've used compilers like that...

cheers, Joe

