Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbXLGER6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbXLGER6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXLGERs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:17:48 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45524
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752772AbXLGERr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:17:47 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [patch] ext2: xip check fix
Date: Thu, 6 Dec 2007 22:17:39 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: carsteno@de.ibm.com, "Nick Piggin" <npiggin@suse.de>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <axboe@kernel.dk>
References: <20071204042628.GA26636@wotan.suse.de> <200712061211.49443.rob@landley.net> <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com>
In-Reply-To: <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062217.40355.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 21:22:25 Jared Hulbert wrote:
> > > I have'nt looked at it yet. I do appreciate it, I think it might
> > > broaden the user-base of this feature which is up to now s390 only due
> > > to the fact that the flash memory extensions have not been implemented
> > > (yet?). And it enables testing xip on other platforms. The patch is on
> > > my must-read list.
> >
> > query: which feature is currently s390 only?  (Execute In Place?)
>
> I think so.  The filemap_xip.c functionality doesn't work for Flash
> memory yet.  Flash memory doesn't have struct pages to back it up with
> which this stuff depends on.

Um, trying to clarify:  S390.  Also known as zSeries, big iron machine, uses 
its own weird processor design rather than x86, x86-64, arm, or mips 
processors.

How does "struct page" enter into this?

What I want to know is, are you saying execute in place doesn't work on things 
like arm and mips?  (I so, I was unaware of this.  I heard about somebody 
getting it to work on a Nintendo DS: 
http://forums.maxconsole.net/showthread.php?t=18668 )

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
