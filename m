Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZKBRAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZKBRAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbZKBRAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:00:12 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53997 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbZKBRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:00:09 -0500
Date: Mon, 2 Nov 2009 11:46:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Message-ID: <20091102164615.GD14046@tuxdriver.com>
References: <1256886023.3555.5.camel@johannes.local> <20091030110616.GB6150@ff.dom.local> <20091030150223.GA2586@tuxdriver.com> <20091102091038.GA9044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102091038.GA9044@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 10:10:38AM +0100, Ingo Molnar wrote:
> 
> * John W. Linville <linville@tuxdriver.com> wrote:

<snip>

> > Ever since Bartlomiej decided to tear himself away from 
> > drivers/staging, he has been nothing but negative -- petty, whining, 
> > indignat, whatever.  Just what has he done to merit any special 
> > consideration here?  Why should he have any sort of veto over rt2x00?
> 
> I got curious, as my past experience with Bartlomiej is that he is a 
> factual, reliable, knowledgable upstream driver developer interested in 
> difficult pieces of code others are reluctant to touch, for whom it is 
> rather atypical to get 'petty, whining, indignant'.
 
YMMV...

<snip>

> Bartlomiej's reply (<1255792104.3434.2.camel@johannes.local>) ignored 
> the attack (gracefully) and replied to the technical portion only:
> 
>  | > Tell me you're kidding -- comparing 2k duplicated LOC with a driver 
>  | > that ships its own wifi stack?
>  |
>  | Why would I be?
>  |
>  | 1) The patch is submitted to kernel _proper_ not kernel staging so I 
>  | see no excuse for duplicating 2-4 KLOC and it should be fixed.
>  |
>  | 2) The fact that the some staging driver consists in 90% of crap 
>  | doesn't mean that it doesn't have some good design ideas..  (i.e. 
>  | abstracting chipset registers access in a discussed case)
> 
> To which technical point Johannes elected not to reply. (Effectively 
> conceding Bartlomiej's point as per lkml discussion rules.)

Really?  "Last post wins" is the rule?  I hope you are joking...

> I can understand David trusting your judgement and not wanting to get 
> involved in the fine details, but having read the surrounding discussion 
> i dont understand your interpretation of the events, and i dont 
> understand on what basis you launched your very serious accusation, that 
> he is being 'petty, whining, indignant'. Every reply from him in that 
> thread is the exact opposite of that. Care to elaborate?

Despite your links, we seem to be reading different threads.  I'm not
sure I can reach your conclusions even with the most generous reading
of Bartlomiej's posts and the most critical readings of _everyone_
else's.

It seems Bartlomiej has taken it personally that we don't like having
the Ralink vendor drivers in the staging tree and he has decided to be
an irritant in linux-wireless as some sort of revenge.  As a bonus,
he has thrown-in some random ramblings attacking the inclusion of
Pulseaudio in Fedora and criticizing Dave's handling of the ide tree.
And worst of all he has chosen to make a big stink about whether or
not the rt2x00 family of drivers (which shares tons of code already,
BTW) is sharing enough code for his taste in drivers that are currently
under active development.

Now you have come along to defend him for whatever your reasons,
and you have chosen to act as if Bartlomiej has been ignored simply
because you don't like the responses he got.  Further, you seem to
expect me to have given him some veto over a driver for which has
has contributed essentially nothing[1].  Why?  Simply because he doesn't
agree with the driver maintainer's JUDGMENT CALL?  Or mine?  Or Dave's?
And for all his objections, he can't be bothered to offer a patch?

I can only guess as to why you are being deferential to Bartlomiej
and overlooking not only how he has treated the rest of us but also
that his technical complaint is minor.  I can only ask you to consider
that maybe Bartlomiej is not so aggrieved as he claims.

John

[1] Even his bug reports and code reviews have clearly been from the
perspective of "you should just be using the staging driver".
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
