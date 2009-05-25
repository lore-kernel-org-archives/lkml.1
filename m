Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZEYU4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZEYU4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZEYU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:56:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49678 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZEYUz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:55:59 -0400
Date: Mon, 25 May 2009 23:54:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090525205459.GC6856@redhat.com>
References: <20090525184816.GB6649@redhat.com> <Pine.LNX.4.44L0.0905251621320.26833-100000@netrider.rowland.org> <ac3eb2510905251341j41493d44ta814018cede2df8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510905251341j41493d44ta814018cede2df8c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 10:41:11PM +0200, Kay Sievers wrote:
> On Mon, May 25, 2009 at 22:37, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > As far as I can tell, this has nothing to do with any user programs in
> > the distribution.  It appears to be entirely the device's fault.
> 
> Sounds good. Maybe we can just double-check.
> 
> Michael, if you do:
>   killall udevd
> do you see the same issue when connecting the device?
> 
> That would tell us if some userspace tool is involved here, which
> hooks into the udev events.
> 
> You can just start udev again by:
>   udevd -d
> 
> Thanks,
> Kay

Same thing.

-- 
MST
