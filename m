Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZEBGi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZEBGi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 02:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZEBGis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 02:38:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZEBGir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 02:38:47 -0400
Date: Sat, 2 May 2009 02:38:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Andrew Tridgell <tridge@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090502063846.GB7905@infradead.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502021258.GJ7681@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502021258.GJ7681@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 10:12:58PM -0400, Theodore Tso wrote:
> So I don't believe removing the code is the right thing to do.  I do
> believe that giving people who build and use the Linux kernel choice
> is a good thing; consider that digital cameras manufactures have
> adhered to a 8.3 filenames, which is encoded in the DCIM standard, for
> 15+ years --- and I don't believe that's an accident.  What might lead
> one company to settle and another one to fight and another to decide
> to evade the issue, may depend on many things, and may have very
> little have to do with Truth or Ethics or Morality.  Welcome to the
> law and business as practiced in our civilized society.

Still not reason to make this a config option.  There's not reason Tom
Tom can't just put a patch in to disable what they want.

Then again I have the feeling this whole thing goes deeper than people
want to make it appear.  When a patch authored by person A gets sent by
person B with a total nonsense patch description talking around the
reason why it's submitted Ccing a dozend people something is fishy and I
want this resolved first.

> (But hey, at least we don't torture people!  :-)

We don't?  Guess I missed the memo..

