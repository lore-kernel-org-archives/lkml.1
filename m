Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbXIRRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbXIRRa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760073AbXIRR3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:29:49 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:23363 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759817AbXIRR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:29:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Md4NnfbSuLktti9cIZ4ZwkCLJtr/lfU3G6FLgJr9ID8RAyGJJTqTjdYxLLtesL9ZkXeSswhrWOf25tKdp4dnHWKwyt+ZNVo3mjawEy1DPSrjYHOtQREyoPl+yvo72rsGDUk+k5vveeJm1FEYgYOuovOFPr5cnBo/VKIbEPcKh3c=  ;
X-YMail-OSG: BzQzaA8VM1mnBVEtOiufhEhh.vbVPWva1xisWmIBV0kM9KV1sRX1pzDN6XjPUEApMKXmeRIJug--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 18 Sep 2007 10:11:17 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
References: <20070911060349.993975297@sgi.com> <200709161903.37295.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709181011.17975.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 08:00, Christoph Lameter wrote:
> On Sun, 16 Sep 2007, Nick Piggin wrote:
> > I don't know how it would prevent fragmentation from building up
> > anyway. It's commonly the case that potentially unmovable objects
> > are allowed to fill up all of ram (dentries, inodes, etc).
>
> Not in 2.6.23 with ZONE_MOVABLE. Unmovable objects are not allocated from
> ZONE_MOVABLE and thus the memory that can be allocated for them is
> limited.

Why would ZONE_MOVABLE require that "movable objects should be moved
out of the way for unmovable ones"? It never _has_ any unmovable objects in
it. Quite obviously we were not talking about reserve zones.
