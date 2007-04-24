Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbXDXBiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbXDXBiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXDXBiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:38:05 -0400
Received: from smtp3.cc.ksu.edu ([129.130.7.17]:52404 "EHLO smtp3.cc.ksu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbXDXBiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:38:03 -0400
Date: Mon, 23 Apr 2007 20:38:01 -0500 (CDT)
From: Amit Gud <gud@cis.ksu.edu>
To: Arjan van de Ven <arjan@infradead.org>
cc: Theodore Tso <tytso@mit.edu>, Kalpak Shah <kalpak@linsyssoft.com>,
       Karuna sagar K <karunasagark@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ChunkFS - measuring cross-chunk references
In-Reply-To: <Pine.LNX.4.64.0704232014571.10676@camaro.cis.ksu.edu>
Message-ID: <Pine.LNX.4.64.0704232031040.10676@camaro.cis.ksu.edu>
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com> 
 <462B8D0C.7020509@ksu.edu>  <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com>
  <1177320876.23226.7.camel@garfield>  <20070423205333.GZ5967@schatzie.adilger.int>
  <20070424001306.GB1663@thunk.org> <1177376549.3244.0.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0704232014571.10676@camaro.cis.ksu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Amit Gud wrote:

> On Mon, 23 Apr 2007, Arjan van de Ven wrote:
>
>> 
>> >  The other thing which we should consider is that chunkfs really
>> >  requires a 64-bit inode number space, which means either we only allow
>>
>>  does it?
>>  I'd think it needs a "chunk space" number and a 32 bit local inode
>>  number ;) (same for blocks)
>> 
>
> For inodes, yes, either 64-bit inode or some field for the chunk id in which 
> the inode is. But for block numbers, you don't. Because individual chunks 
> manage part of the whole file system in an independent way. They have their 
> block bitmaps starting at an offset. Inode bitmaps, however, remains same.
>

In that sense, we also can do away without having chunk identifier encoded 
into inode number and chunkfs would still be fine with it. But we will 
then loose inode uniqueness property, which could well be OK as it is with 
other file systems in which inode number is not sufficient for unique 
identification of an inode.


AG
--
May the source be with you.
http://www.cis.ksu.edu/~gud
