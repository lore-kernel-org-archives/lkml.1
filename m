Return-Path: <linux-kernel-owner+w=401wt.eu-S1763569AbXLTXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763569AbXLTXQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXLTXQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:16:05 -0500
Received: from smtp.ono.com ([62.42.230.12]:2955 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752158AbXLTXQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:16:04 -0500
Date: Fri, 21 Dec 2007 00:14:48 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
       apw@shadowen.org, lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       elendil@planet.nl, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       trivial@kernel.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071221001448.31361086@werewolf>
In-Reply-To: <20071220220853.4f7c639c@the-village.bc.nu>
References: <1196390128.22120.118.camel@localhost>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
	<20071220.135133.262055434.davem@davemloft.net>
	<1198188468.6183.80.camel@localhost>
	<20071220220853.4f7c639c@the-village.bc.nu>
X-Mailer: Claws Mail 3.2.0cvs10 (GTK+ 2.12.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 22:08:53 +0000, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I believe though that printk messages are not sentences but are
> > logging statements.  Statements do not require full-stops.
> > 
> > Opinions, of course, vary.
> 
> I do not believe "opinions" are relevant here. Relevant would be cites
> from respected style guides (Fowlers, Oxford Guide To Style et al.) to
> show they do not need a full stop. 
> 

All those fine references you cite are sure written for read literate
(literacy?) texts. Punctuation is something that is needed in (just
forgive me 'cause I'm trying to think this in english, but spanish is
my native language...) continous written text that needs some kind of
symbol to show there is a pause half in a sentence (a comma), or that
two statements are separate sentences and need to be declaimed specially.

Nobody (someone?) has written a guide to declaim computer messages or
source code. If you get so picky, this message

[kajasldkjasl] Kernel OOPS: sdsdsdsdsd

shoud read:

At [kajasldkjasl], the kernel has tried to deliver an operation that
resulted in an inconsistent state, so system operation has been stopped...

>From my point of view:
- Kernel messages are not read at loud...
- If you are so worried about extra chars/mem usage in other areas, the
  dot at the end of a kernel message is just trash.
- If some kernel message has two sentences, better to format them in
  two lines (ie, sed -e :.:\n:g:)

If some kernel message needs grammatical corrections, it is not a kernel
message, it was someone very bored when he wrote the code.

The kernel messages are _not_ sentences, they are kernel messages.
If not, you have a harder work assuring they all have a subject and
a predicate than worrying about dots at the end...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
