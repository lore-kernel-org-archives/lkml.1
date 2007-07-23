Return-Path: <linux-kernel-owner+w=401wt.eu-S1765540AbXGWUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765540AbXGWUF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXGWUFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:05:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbXGWUFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:05:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>, Alan Modra <amodra@bigpond.net.au>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
In-Reply-To: Al Viro's message of  Monday, 23 July 2007 20:39:24 +0100 <20070723193923.GL21668@ftp.linux.org.uk>
X-Zippy-Says: FROZEN ENTREES may be flung by members of opposing SWANSON SECTS..
Message-Id: <20070723200500.3BBF94D058D@magilla.localdomain>
Date: Mon, 23 Jul 2007 13:05:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jul 23, 2007 at 12:12:15PM -0700, Roland McGrath wrote:
> > > rm vmlinux*; time make vmlinux
> > > 
> > > Vanilla tree: ~7,7 sec
> > > With single shot ld (Roland's patch): 8,3 secs
> > 
> > Shouldn't you compare:
> > 	rm vmlinux*; find . -name built-in.o -print | xargs rm
> > 	time make vmlinux
> > or something like that?
> 
> No.  You are talking about the time of full build; there it would
> be relevant.  For incrementals it's definitely not so.

Ah, I see what you are testing.  Well, a fair test then is to do something
that would actually happen, which is almost never just "rm vmlinux".
i.e., at least one ld -r -o foo/built-in.o from changing one source file.


Thanks,
Roland
