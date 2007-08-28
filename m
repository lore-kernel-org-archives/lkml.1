Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbXH1RKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbXH1RKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbXH1RKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:10:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:44718 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbXH1RKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mk7K9EMokZJm9lN9X/7YEkOMQj65OFLFUCBnKImWOgnpDE07IX5JsnC1cjcsgnaKKIbcLOegsS6HRgGjq8FNNGg1OcqEbFyjvFO/E0/d2BYnnBsBzXFS6+xGc9W7BgUdd8GrDmNw8tWf4uPTQtepG7gSM4B3xGNtoUKZFu7ONsg=
Message-ID: <4877c76c0708281010x4597a9cfpc252dc4ee2a0ef9e@mail.gmail.com>
Date: Tue, 28 Aug 2007 10:10:05 -0700
From: "Michael Evans" <mjevans1983@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Michael J. Evans" <mjevans1983@comcast.net>,
       "Neil Brown" <neilb@suse.de>, "Ingo Molnar" <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <46D44A09.5060901@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708222058.45480.mjevans1983@comcast.net>
	 <200708271516.21889.mjevans1983@comcast.net>
	 <20070827153020.43788e21.randy.dunlap@oracle.com>
	 <200708272138.19785.mjevans1983@comcast.net>
	 <46D3A8AD.6000701@oracle.com>
	 <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>
	 <46D421F6.50205@tmr.com>
	 <4877c76c0708280632t3eb40d01od1267c8c4a7d8de@mail.gmail.com>
	 <46D44A09.5060901@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Michael Evans wrote:
> > On 8/28/07, Bill Davidsen <davidsen@tmr.com> wrote:
> >> Michael Evans wrote:
> >>> Oh, I see.  I forgot about the changelogs.  I'd send out version 5
> >>> now, but I'm not sure what kernel version to make the patch against.
> >>> 2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
> >>> Additionally I never could tell what git tree was the 'mainline' as it
> >>> isn't labeled with such a keyword (at least in the list of git trees I
> >>> saw).
> >>
> >> I suspect you wait for 2.5.23 release, or send it to AKPM for inclusion
> >> in an "-mm" kernel. That's probably desirable, anyway.
> >>
> >> --
> >
> > There's another list I should CC to?  Or does the section maintainer
> > do that when they're happy with the patch?
>
> Not another list; just cc: akpm@linux-foundation.org so that he can merge
> it into the -mm kernel patches for testing.  Most patches cook in the -mm
> kernel(s) before they are merged into mainline.
>
> Then generally the subsystem maintainer(s) are responsible for sending
> patches on to Linus for merging into mainline, if/when they are happy
> with the patch and they think that it has been tested enough.
>

So I should look at the git documentation again, try to pull down
Andrew's latest -mm, and see what I need to change (if anything) to
patch against it?  (I would probably only verify that boots once my
self given the other testing this has already seen and how often mm
breaks things my mythtv box likes, such as nvidia-drivers, etc,)

> Mainline progresses (roughly, e.g.) like so:
>

I knew about the progression order (but not timing) of the non-git
side of it, but it was helpful to have the whole thing spelled out,
thank you.
