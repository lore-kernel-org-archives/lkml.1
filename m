Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYLDJ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYLDJ4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYLDJ4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:56:23 -0500
Received: from web15702.mail.cnb.yahoo.com ([202.165.102.69]:24694 "HELO
	web15702.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750763AbYLDJ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:56:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=1upl8AL/oW4H95ZWawCtjELzguLodGhsmFrogNFtY4LhFWx9iWIitS/AXE2fY2mEfyYUXCoMrtLQcPIIHzWWHpX8/i9a3cu9FoyXylYA9TmUnU3ukmH1mHo63lCXgcBRx6plvCQNPjd6/QLGYXheUmlZseGKjbuOgfHF+5tCrLQ=;
X-YMail-OSG: .My8r.8VM1mLjfT_t2CoNkFoLajTvs5g7h9bQBY.cPYBVQfKM62yybSbHjNyE0Bofk1T_dSQo2wgDFeDhJLamIS_j3VqmeafBHM_cLas_8ZP_V77mHzqBO6gLwrC3CxFjDpApmeSqe6UXuGKUOFvEmJ9urkXpOpZGAqihmd5KzttX5Q-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 4 Dec 2008 17:56:19 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: Re: question related page frame reclaim on embedded system
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081203103641.1D32.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <478468.3916.qm@web15702.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,Kosaki

1. what happens if used IPC share memory ?
   As i knew IPC share memory  use anonymous mapping ,but not sure my understand is correctly .

Thanks advanced .
Best Regards.
Peter


--- On Wed, 12/3/08, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Subject: Re: question related page frame reclaim on embedded system
> To: mengsanshui@yahoo.com.cn
> Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
> Date: Wednesday, December 3, 2008, 9:48 AM
> > 
> > Hi,Kosaki
> > 
> > Thank you very much .
> > I have another question about share memory . Assume a
> process create a share memory ,
> > seems the page that the process used can not be
> discard or swap out
> 
> No. Linux can swap out COW shared memory too. see swap
> cache related code.
> Also, Linux can discard non-dirty and file mapped shared
> page.
> 
> but, yes.
> Linux can't discart dirty or anonymous mapped page.
> 
> 
> > when they are no longer used by any process or no swap
> space .
> > 
> > 1.whether the maped page of the share memory is
> persistent in system until
> >   system restart ? if not how page frame reclaiming
> process it ? 
> 
> No.
> Linux manage page reference count.
> forrk increment it. exit decrement it.
> So, when process exiting, Linux can discard non used page
> immediately.
> 
> IOW, reclaim provide "page discard/swap although page
> is still used" mechanism.


      
