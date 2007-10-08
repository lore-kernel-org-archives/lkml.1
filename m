Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbXJHGES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbXJHGES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXJHGEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:04:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46056
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbXJHGEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:04:08 -0400
Date: Sun, 07 Oct 2007 23:04:07 -0700 (PDT)
Message-Id: <20071007.230407.07619446.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: arnd@arndb.de, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       hch@lst.de
Subject: Re: [patch 0/9] compat_ioctl: introduce block/compat_ioctl.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071008051218.GS8181@ftp.linux.org.uk>
References: <20071006181902.141862534@arndb.de>
	<20071008051218.GS8181@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 8 Oct 2007 06:12:18 +0100

> On Sat, Oct 06, 2007 at 08:19:02PM +0200, Arnd Bergmann wrote:
> > This is my block ioctl series split up into managable chunks. I'm not
> > really sure about the last two of these, I'd prefer to get a second
> > opinion on those.
> > 
> > Please apply once your tests have gone though.
> 
> BTW, one note: 0x1260 thing (
>        /* The mkswap binary hard codes it to Intel value :-((( */
>        case 0x1260:
>        case BLKGETSIZE:
> ) is an ancient piece of BS.  It had appeared in 2.1.115-pre3 and AFAICS
> it's a misunderstanding.
 ...
> IOW, that stuff is useless and always had been.  In the current form it's
> simply invalid C on e.g. amd64 - you get duplicate case there, which breaks
> the build.
> 
> I'd simply kill that.

Agreed.
