Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZAJMo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZAJMo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZAJMoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:44:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbZAJMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:43:59 -0500
Date: Sat, 10 Jan 2009 13:43:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090110124335.GB30744@elte.hu>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090109211937.GA14342@logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Fri, 9 January 2009 11:37:39 -0800, David Brown wrote:
> > On Fri, Jan 09, 2009 at 05:54:22PM +0100, Jörn Engel wrote:
> > >
> > > In general, filesystems and ABI changes are special because stupid 
> > > mistakes are eternal.  If some device driver has a bug, you can fix 
> > > it, reboot and be done with it.  Not so with filesystems.
> > 
> > Squashfs is readonly from the kernel.  The images are created with 
> > userspace tools.
> 
> While true, it doesn't make a difference.  If, for example, your 
> structures members are not naturally aligned, you take a performance hit 
> for no good reason.  Simply moving fields around would make the code go 
> faster.  But the format is fixed and prevents you from making this 
> change.
> 
> You have to get those things right from the beginning or pay for your 
> mistakes everafter.  In general (and I stress "In general") filesystems 
> want more review than ordinary device drivers.  And just to stress that 
> again, this is not an argument against merging squashfs now.

What does a performance hit have to do with an ABI? Absolutely nothing - 
if such a bug is noticed it is fixed, that's it. Your argument does not 
parse and makes absolutely zero technical sense.

Your "ABI is forever" objection against a _read only_ filesystem is a 
newbie mistake worthy of cookie file inclusion - i had a real good laugh 
when i read it ;-)

	Ingo
