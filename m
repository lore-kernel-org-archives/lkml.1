Return-Path: <linux-kernel-owner+w=401wt.eu-S1030936AbXD1Cuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030936AbXD1Cuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030952AbXD1Cuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:50:39 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:20130 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030936AbXD1Cuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:50:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=P8L3VC46DF1/KFdCl3cbCpsz1i2MVEiYoVkNPny4d/m7PJvxHWzsOW/C8cJ7umzIwjuGIdPZV+Gs6+GbeFMop8TVTLqbC12ydU1QFReYI1q5vip7ZR7B7AixVlKrrRG7jeB7rrlXg2nzupVaXmYJOyve+aNWRKDA0HthjoUDEyU=  ;
X-YMail-OSG: 8FjGm7UVM1l7.uGct0XAKLvAMvOSgoKNqHoaTb05CfZknTW50AmHlnl0Ha_qBPtd.Oz8VH.B7g--
Message-ID: <4632B672.90609@yahoo.com.au>
Date: Sat, 28 Apr 2007 12:50:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com> <4631EBC8.4060003@yahoo.com.au> <20070427133947.GB4152@infradead.org> <4632B121.3030005@yahoo.com.au> <20070428023901.GT19966@holomorphy.com>
In-Reply-To: <20070428023901.GT19966@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Sat, Apr 28, 2007 at 12:27:45PM +1000, Nick Piggin wrote:
> 
>>I guess 10% isn't a small amount. Though it would be nice to have
>>before/after numbers for Linux. And, like Andrew was saying, we could
>>just _attempt_ to put contiguous pages in pagecache rather than
>>_require_ it. Which is still robust under fragmentation, and benefits
>>everyone, not just files with a large pagecache size.
> 
> 
> What sort of strategy do you intend to use to speculatively populate
> the pagecache with contiguous pages?

Andrew outlined it.

-- 
SUSE Labs, Novell Inc.
