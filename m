Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYCEQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYCEQCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYCEQCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:02:25 -0500
Received: from n29.bullet.mail.mud.yahoo.com ([68.142.200.152]:38568 "HELO
	n29.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754674AbYCEQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:02:24 -0500
X-Yahoo-Newman-Id: 282562.90815.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XpjGMY47icrpf2+ATK5HIOn1SzDfDQN1oOX3QoSAKXySrqHh8P+UA/PElIYd/UpSDRSohf0iNzODje8+te3CCrjHKJ4bEeyrcuGIaOkzu4qheVB7xHJSrJzU1GGLcACzoX6jz2zZvbPzme7m67U6TXhEjFRrAMCBF6ZysEB2W6I=  ;
X-YMail-OSG: In8m2NUVM1kQ9FU3byAQQgqxuywqKrCyPCr89OBX7k0AGTw41nwIEtdhSKi9Sj.o_HrMXB9dng--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
Date: Thu, 6 Mar 2008 03:02:06 +1100
User-Agent: KMail/1.9.5
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "David Miller" <davem@davemloft.net>,
       dmantipov@yandex.ru, linux-kernel@vger.kernel.org
References: <1389671204703217@webmail34.yandex.ru> <200803060238.39484.nickpiggin@yahoo.com.au> <2c0942db0803050755u7e17118h923328fb79ee206b@mail.gmail.com>
In-Reply-To: <2c0942db0803050755u7e17118h923328fb79ee206b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060302.07084.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 02:55, Ray Lee wrote:
> On Wed, Mar 5, 2008 at 7:38 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> >  Yeah, but why does the pipe inode need to have its times updated?
> >  I guess there is some reason... hopefully not C&P related.
>
> In principle so that the reader or writer can find out the last time
> the other end did any processing of the pipe. And yeah, for POSIX
> compliance: "Upon successful completion, pipe() will mark for update
> the st_atime, st_ctime and st_mtime fields of the pipe. "

Thanks.

> But it'd be 
> nice if there were a way to avoid touching it more than once a second
> (note the 'will mark for update' language). Or if the pipe is a
> physical FIFO on a noatime filesystem?

I doubt it really matters for anything except this test. I wouldn't
bother doing anything fancy really. It just caught my eye and I was
wondering why it was there at all.

Thanks,
Nick

