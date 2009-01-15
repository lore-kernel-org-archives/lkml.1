Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbZAOGps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbZAOGps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZAOGph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:45:37 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:45198 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754141AbZAOGpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:45:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M+UkNp5hFka+hUOe7AhN95itHRASns/18eEYcKOOsUpjfllrNsLyCsrBhr+OBkNQyuTWFAzA4s4TQcdKhG6+yzNX5SQN4yJlz8hvI3d/6eUaryA2G7JhIAzwMlcJ/B3KOxC6dpA55RoTqNOOmdYwcs/GpOljbvio1EFvrj2FQIM=  ;
X-YMail-OSG: VJpi26IVM1lo7.V_tlZc0aZH300n3jVTpOZkgQ8vjZ4KeF5ohp2Q9tRr7tBn0rrO3_HYv44euSgtJj_GVTj3JprnAfLn.BtlzuCFVyuA.MGWdevQeoxHrUl8kTgNWdASV6c_mKj7btsfyBVS47I9YlASPF9qO34XLyTKQDD7CF5xyH50E_UNXAziRCTcuQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: 2.6.29 -mm merge plans
Date: Thu, 15 Jan 2009 17:45:13 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       konishi.ryusuke@lab.ntt.co.jp
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <200901071321.43068.nickpiggin@yahoo.com.au> <E1LKqPt-000287-U3@pomaz-ex.szeredi.hu>
In-Reply-To: <E1LKqPt-000287-U3@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151745.14610.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009 19:39:02 Miklos Szeredi wrote:
> On Wed, 7 Jan 2009, Nick Piggin wrote:
> > I don't know how stable fuse APIs are (ie. whether we'd just be handing
> > the anchors to FUSE), but if it is very stable, then it would be nice to
> > push a lot of them out of the kernel (although OTOH the old ones tend not
> > to have complex interactions with mm or block layer).
>
> Fuse APIs are very stable, so pushing old filesystems out to userspace
> makes sense.  Porting them, however, is not entirely trivial.  Amit
> Singh (of MacFUSE) got minix, ufs and sysvfs to work on OSX using only
> lightly modified linux source code.  That framework could probably be
> used to port other filesystems to userspace.

That might be nice. OTOH it is just a random suggestion from me. I don't
know what core fs developers think about requiring fuse and user code to
mount these old things...

Would we have to distribute the user code with the kernel? I guess then
we would still need to maintain it, but I guess the key improvement would
be that fuse APIs are very stable.

