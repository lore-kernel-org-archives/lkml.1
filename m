Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZEASTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZEASTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZEASTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:19:39 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:37688 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbZEASTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:19:38 -0400
Message-ID: <49FB3D37.5060509@msgid.tls.msk.ru>
Date: Fri, 01 May 2009 22:19:35 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <1241199689.13073.6.camel@norville.austin.ibm.com>	 <20090501174757.GC8104@infradead.org> <1241201562.13073.30.camel@norville.austin.ibm.com>
In-Reply-To: <1241201562.13073.30.camel@norville.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:
> On Fri, 2009-05-01 at 13:47 -0400, Christoph Hellwig wrote:
>> On Fri, May 01, 2009 at 12:41:29PM -0500, Dave Kleikamp wrote:
>>> From: Andrew Tridgell <tridge@samba.org>
>>> Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
>>>
>>> When this option is enabled the VFAT filesystem will refuse to create
>>> new files with long names. Accessing existing files with long names
>>> will continue to work.
>>>
>>> File names to be created must conform to the 8.3 format.  Mixed case is
>>> not allowed in either the prefix or the suffix.
>> This doesn't make any sense as a compile time option. Might make sense
>> as a mount option, but I'd like to hear a rationale for it first.
> 
> Some linux-based devices would be happy not to contain code to create
> the long name at all.

Well, is that a rationale per se?  Which devices they are and why?

But besides, why `msdos' filesystem is not sufficient?
It contains no code to create long file names and no code to
read such names either.

/mjt
