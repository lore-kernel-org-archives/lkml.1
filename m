Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZEZGTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZEZGTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZEZGTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:19:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbZEZGTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:19:21 -0400
Date: Tue, 26 May 2009 09:17:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090526061710.GF6856@redhat.com>
References: <20090525205353.GB6856@redhat.com> <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org> <20090525214755.GE6856@redhat.com> <20090525223120.GC11648@ub> <ac3eb2510905251605k5491f271q6432ccaef3e653fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905251605k5491f271q6432ccaef3e653fd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 01:05:00AM +0200, Kay Sievers wrote:
> On Tue, May 26, 2009 at 00:31, Andries E. Brouwer
> <Andries.Brouwer@cwi.nl> wrote:
> 
> > I can imagine that your device is a slow starter and needs some time
> > to initialize itself, so that the first, or the first few, commands fail,
> > and after that all is well.
> 
> Michael, what's the value of:
>   /sys/module/usb_storage/parameters/delay_use
> ?
> 
> If that is less than 5 seconds, care to try if setting it to 5 makes
> any difference?
> 
> Kay

It's 5 already.

-- 
MST
