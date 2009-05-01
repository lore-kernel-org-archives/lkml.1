Return-Path: <linux-kernel-owner+w=401wt.eu-S1764689AbZEASMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764689AbZEASMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZEASMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:12:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52140 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZEASMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:12:44 -0400
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090501174757.GC8104@infradead.org>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	 <20090501174757.GC8104@infradead.org>
Content-Type: text/plain
Date: Fri, 01 May 2009 13:12:42 -0500
Message-Id: <1241201562.13073.30.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 13:47 -0400, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 12:41:29PM -0500, Dave Kleikamp wrote:
> > From: Andrew Tridgell <tridge@samba.org>
> > Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
> > 
> > When this option is enabled the VFAT filesystem will refuse to create
> > new files with long names. Accessing existing files with long names
> > will continue to work.
> > 
> > File names to be created must conform to the 8.3 format.  Mixed case is
> > not allowed in either the prefix or the suffix.
> 
> This doesn't make any sense as a compile time option. Might make sense
> as a mount option, but I'd like to hear a rationale for it first.

Some linux-based devices would be happy not to contain code to create
the long name at all.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

