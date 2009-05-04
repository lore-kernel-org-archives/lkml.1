Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZEDRto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZEDRto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZEDRte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:49:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35930 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZEDRtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:49:33 -0400
Date: Mon, 4 May 2009 10:49:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       tridge@samba.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504174931.GG6740@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1d4ao4wj2.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4ao4wj2.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 10:18:09AM -0700, Eric W. Biederman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Mon, May 04, 2009 at 09:30:20AM -0700, Eric W. Biederman wrote:
> >> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
> >> 
> >> > That's for the maintainers to decide.  If they agree it has worth, maybe
> >> > it's a good idea to answer "How".
> >> 
> >> Al and Christoph said essentially the same thing and they generally
> >> are considered the general area filesystem maintainers.
> >> 
> >> This kind of thing does not appear to have come up before and
> >> so procedurally you guys are setting are attempting to set
> >> a precedent.
> >> 
> >> All I know is that doing it the way you are doing seems like a bad
> >> idea.  Not discussing things or even the reason you can't discuss them
> >> seems foolish and leaves no one satisfied.
> >> 
> >> Maybe there are good reasons but so far this whole thing just stinks.
> >> 
> >> When all of the pieces are public how can having secret veiled reasons
> >> make sense?
> >> 
> >> And if secret magic consultations with lawyers are going to be invoked
> >> I expect we should have a Signed-off-by from those lawyers.
> >
> > ;-)
> >
> > Matthew's idea of checking with SFLC seems to me to have some merit.
> > I am looking into this from my end.  Of course, you and Al and Christoph
> > have just as much standing to ask SFLC as do I, and perhaps more.
> 
> Reasonable.  Of course it still misses one interesting point.
> 
> Typically when reviewing code if the code looks suspicious you ask the
> poster why they did X.  If the author of the code has a good answer
> you can tell that they have done their homework, and you can verify it.
> If the author doesn't have a good answer typically that means they haven't
> thought through all of the details and the code has problems.
> 
> In this case we ask why and get stone-walling.  Which typically would
> mean either that IBM has a good reason for doing this that they are
> keeping hidden.  Or that we have programmers reacting to news stories
> who have not done all of their homework.
> 
> So far my feeling has been, that there are people handling this mess
> on other fronts and that if it was a real issue they would be coming
> out of the wood work, and giving guidance.
> 
> Now perhaps no one is because this is a cross disciplinary thing and no
> one has sufficient legal, technical and business expertise.

It certainly is a cross-disciplinary thing.

> Right now my hypothesis that best fits the facts is programmers reacting
> on their own to news stories, without having done all of their homework.

Not the case, I assure you.  However, you are of course free to believe
whatever you choose.

> Asking others to go to the SFLC or other places and do your homework
> for you is an interesting reaction.  The SFLC does seem like an
> appropriate group to get an opinion from.

Ah, but you are not simply asking us to -do- our homework, but also to
make that homework public on LKML.  Please note that Matthew's earlier
email indicates that he does not expect to be able to convince his
employer to make such homework public.

As to requesting that SFLC weigh in, those of you from smaller
organizations might be able to accelerate this process significantly
should you care to do so.

							Thanx, Paul
