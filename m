Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXGQBKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXGQBKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXGQBJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:09:40 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:40328 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbXGQBJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:09:38 -0400
X-Greylist: delayed 744 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 21:09:38 EDT
To: nix.or.die@googlemail.com
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       torvalds@linux-foundation.org, linux-scsi@vger.kernel.org
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <469C10F6.3050008@googlemail.com>
References: <469BD9C8.4000808@googlemail.com>
	<469C10F6.3050008@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070717100921W.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 17 Jul 2007 10:09:21 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Tue, 17 Jul 2007 02:44:38 +0200

> Gabriel C wrote:
> > Hello,
> >
> > sdparm and hdparm are broken for me on git (
> > abce891a10559343d8ac9f79b46d78afdba63a40 )
> >
> >
> > ~$ sudo hdparm  /dev/sdc
> >
> > /dev/sdc:
> >  BLKROGET failed: Inappropriate ioctl for device
> >  BLKRAGET failed: Inappropriate ioctl for device
> >  BLKGETSIZE failed: Inappropriate ioctl for device
> >
> >
> > ~$ sudo sdparm  --all /dev/sdc
> > unable to access /dev/sdc, ATA disk?
> >
> >   
> 
> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.

Can you check the major number of your /dev/sdc? I've seen that
/dev/sd* is linked to bsg devices somehow.


> Maybe a bit off topic but it depends on EXPERIMENTAL so why the the menu
> is not telling this ? and why the default is 'y' for it ?
> 
> IMO everything depends on EXPERIMENTAL should
> 
> 1) Tell it is EXPERIMENTAL ( visible to the user in menu ) " Foo New
> stuff ( EXPERIMENTAL ) "
> 2) Should not default to 'y' , is up to the users/admins to set
> EXPERIMENTAL things to Y/M , isn't it ?
> 
> 
> ( PS: there are even defconfigs with EXPERIMENTAL things set to y but
> this is really off topic )

I'll fix it, thanks.
