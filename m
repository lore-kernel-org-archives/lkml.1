Return-Path: <linux-kernel-owner+w=401wt.eu-S935849AbXGRX0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935849AbXGRX0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936141AbXGRXZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:25:55 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44816 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762406AbXGRXZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:25:53 -0400
To: nix.or.die@googlemail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <469C1E2A.8010508@googlemail.com>
References: <469C10F6.3050008@googlemail.com>
	<20070717100921W.fujita.tomonori@lab.ntt.co.jp>
	<469C1E2A.8010508@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070719082516W.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 19 Jul 2007 08:25:16 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Tue, 17 Jul 2007 03:40:58 +0200

> FUJITA Tomonori wrote:
> > From: Gabriel C <nix.or.die@googlemail.com>
> > Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
> > Date: Tue, 17 Jul 2007 02:44:38 +0200
> >
> >   
> >> Gabriel C wrote:
> >>     
> >>> Hello,
> >>>
> >>> sdparm and hdparm are broken for me on git (
> >>> abce891a10559343d8ac9f79b46d78afdba63a40 )
> >>>
> >>>
> >>> ~$ sudo hdparm  /dev/sdc
> >>>
> >>> /dev/sdc:
> >>>  BLKROGET failed: Inappropriate ioctl for device
> >>>  BLKRAGET failed: Inappropriate ioctl for device
> >>>  BLKGETSIZE failed: Inappropriate ioctl for device
> >>>
> >>>
> >>> ~$ sudo sdparm  --all /dev/sdc
> >>> unable to access /dev/sdc, ATA disk?
> >>>
> >>>   
> >>>       
> >> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.

I've not tested this yet (need to find sata drives in my workplace),
but James Bottomley told me that both works for him with bsg enabled.
It might worth trying the latest git tree.
