Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZEATJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZEATJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbZEATJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:09:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35132 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbZEATJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:09:36 -0400
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Christoph Hellwig <hch@infradead.org>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <49FB3D37.5060509@msgid.tls.msk.ru>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	 <20090501174757.GC8104@infradead.org>
	 <1241201562.13073.30.camel@norville.austin.ibm.com>
	 <49FB3D37.5060509@msgid.tls.msk.ru>
Content-Type: text/plain
Date: Fri, 01 May 2009 14:09:33 -0500
Message-Id: <1241204973.13073.55.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 22:19 +0400, Michael Tokarev wrote:
> Dave Kleikamp wrote:
> > On Fri, 2009-05-01 at 13:47 -0400, Christoph Hellwig wrote:
> >> On Fri, May 01, 2009 at 12:41:29PM -0500, Dave Kleikamp wrote:
> >>> From: Andrew Tridgell <tridge@samba.org>
> >>> Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
> >>>
> >>> When this option is enabled the VFAT filesystem will refuse to create
> >>> new files with long names. Accessing existing files with long names
> >>> will continue to work.
> >>>
> >>> File names to be created must conform to the 8.3 format.  Mixed case is
> >>> not allowed in either the prefix or the suffix.
> >> This doesn't make any sense as a compile time option. Might make sense
> >> as a mount option, but I'd like to hear a rationale for it first.
> > 
> > Some linux-based devices would be happy not to contain code to create
> > the long name at all.
> 
> Well, is that a rationale per se?  Which devices they are and why?

Could be anything.  cameras, phones, etc.  Anything that might be
mountable by a host computer in order to share files, or to write to a
device that can be shared by other computers or devices.

> But besides, why `msdos' filesystem is not sufficient?
> It contains no code to create long file names and no code to
> read such names either.

An example, an mp3 player wants to read files with long mixed-case
names, which can be manipulated on a host computer.  But it may not need
to create files that don't fit the 8.3 syntax.

Of course, msdos might be a good option for other devices.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

