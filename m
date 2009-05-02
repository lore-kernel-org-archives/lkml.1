Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZEBBhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZEBBhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 21:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZEBBhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 21:37:31 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45230 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZEBBha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 21:37:30 -0400
Date: Fri, 1 May 2009 18:37:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Andrew Tridgell <tridge@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090502013729.GI6996@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501210109.GA3079@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 05:01:09PM -0400, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 03:18:20PM -0500, Steve French wrote:
> > For those manufacturers who who would like to disable
> > creation of long file names, but allow reading long file names,
> > and handle FAT32 on disk format and maximum sizes, it seems
> > reasonable to give them a simple configure option for it.  It is
> > harder, and less effective, to make the corresponding change
> > to modify the mount helper and kernel code to add
> > a new mount option, because it can be bypassed trivially
> > at the command line (ie having to "force" mount to pass a "nolongfilename"
> > mount option, would be harder than a simple kernel configure option)
> 
> Steve, can you please stop the bullshitting?
> 
> >From the complete lack of technical arguments it's pretty obvious that
> this seems to be some FUD fallout from the MS vs TomTom patent lawsuite.
> 
> I'm not a lawyer so I don't know how much of a threat it is.  But either
> the case gets shot down by showing prior art and everything is fine, or
> we indeed are in deep trouble and should remove it completely.  Given
> the Cc list on here IBM seems to have some legal opinion on it, so can
> we please see it and discuss what we want to with all cards on the
> table?

Hello, Christoph!

Hmmm...  Both Tridge and Dave have Signed-off-by on the original patch,
and Steve has Acked-by, Mingming has Cc, and Dave is on the From list
rather than the Cc list, so I have to guess that there is a good chance
that you are talking about me.  ;-)

However, as far as I know, none of us are lawyers, and LKML is definitely
a technical rather than a legal forum, so we really do need to stick to
technical topics.  I understand that this might be a bit frustrating
to you.  On the other hand, I for one much prefer being in a forum
restricted to technical topics than to be in those places designed to
handle legal topics!

I suspect that this is not the answer that you were looking for, and
I do apologize for any disappointment, but this does happen to be the
answer that I have.

							Thanx, Paul
