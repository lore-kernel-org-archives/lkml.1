Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbXGBOKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbXGBOKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXGBOKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:10:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51800 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbXGBOKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:10:08 -0400
Message-ID: <4689073D.1020802@garzik.org>
Date: Mon, 02 Jul 2007 10:10:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: why does git perpetually complain about include/asm-blackfin/macros.h?
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>	 <4688EF9B.8020405@garzik.org> <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
In-Reply-To: <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 02/07/07, Jeff Garzik <jeff@garzik.org> wrote:
>> Robert P. J. Day wrote:
>> >   for the umpteenth time, after doing a pull, i see this:
>> >
>> > $ git diff
>> > diff --git a/include/asm-blackfin/macros.h 
>> b/include/asm-blackfin/macros.h
>> > deleted file mode 100644
>> > index e69de29..0000000
>> > $
>>
>> I have the same problem.  git 1.5.0.6 on Fedora Core 5 or 6.
>>
>> I even tried a completely fresh clone, but the problem still appears.
>>
> I've seen that as well, but in my case doing a
> $ git reset --hard master
> fixed it.

Sure.  git checkout -f fixes it too.

But then it reappears the every time I switch branches.

	Jeff



