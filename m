Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYLCBaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYLCBaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYLCBa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:30:26 -0500
Received: from web15703.mail.cnb.yahoo.com ([202.165.102.70]:20782 "HELO
	web15703.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752212AbYLCBaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:30:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=DTCwkKOkz7+QF8XYeDU7p06/4XMzQXLN2lgHyVRNGBODHhx54AuMZ931BY+c2G6C0Z6xw4dKHVWZ9FM8xn/PZuq+plUybq/6gCIMxofp1SSeIHbcE05qP3O66pcHbjoGsQquTlEXCzL+77faawJ4UzFpD5lTBiWe0mAKg/4g5WI=;
X-YMail-OSG: 382yuD0VM1kMXvXINpwFcSm5IqgqHfbqoo_Zzjuuwk0QCJrp0NgStulpcZYWVk4sk5XKX.o6su3FVgfLMgqYkN1OA3D8vnzacQOs8KY0NiYDjvMFCNIsMVPNi2XO3ogkpQ3FkP.xNPWBY6AJrhJpyGFscadEXc7MhiTpwxo6SyuQk9I-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Wed, 3 Dec 2008 09:30:22 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: Re: question related page frame reclaim on embedded system
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081202203601.1D24.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <816384.38683.qm@web15703.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,Kosaki

Thank you very much .
I have another question about share memory . Assume a process create a share memory , seems the page that the process used can not be discard or swap out when they are no longer used by any process or no swap space .

1.whether the maped page of the share memory is persistent in system until
  system restart ? if not how page frame reclaiming process it ? 


Thanks advanced 
Best Regards.
Peter Meng 

--- On Tue, 12/2/08, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Subject: Re: question related page frame reclaim on embedded system
> To: mengsanshui@yahoo.com.cn
> Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
> Date: Tuesday, December 2, 2008, 7:40 PM
> > 1, I have a question related page frame reclaim .
> > As i understood , under low memory pressure page frame
> reclaiming will
> > swap  Least Recently Used cache to disk .
> > So my question is assume no swap space ,how to works ?
> > Whether the  Least Recently Used  slab cache , inode
> cache  etc  will
> > be discard since no swap space .
> 
> Yes, page cache and slab cache (include inode cache and
> dentry cache) can be dropped
> although no swap.
> 
> 
> > 2. BTW ,I have already used my gmail account subscribe
> the linux kernel mail list .but can not post the question to
> mail list , i used plain text format . 
> > why ? I have seen many people use account of gmail  to
> post question .
> 
> I don't know.
> I can post by gmail.
> 
> But, One caution.
> gmail web interface is a bit silly. it can't post patch
> because
> it trim tab and space.


      
